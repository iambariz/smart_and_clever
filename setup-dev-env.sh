#!/bin/bash
# One-shot Connect IQ dev environment setup for this project (Ubuntu 26.04+).
# Garmin's own Linux SDK Manager and Simulator GUIs are broken on this distro
# (they link against libwebkit2gtk-4.0, which Ubuntu no longer ships), so this
# uses the community CLI + AppImage workarounds instead of Garmin's installers.
set -e

# 1. Java (required by the Connect IQ compiler)
sudo apt update && sudo apt install -y openjdk-17-jre

# 2. connect-iq-sdk-manager CLI (github.com/lindell/connect-iq-sdk-manager-cli)
mkdir -p ~/.local/bin
curl -Ls -o /tmp/ciq-cli.tar.gz "https://github.com/lindell/connect-iq-sdk-manager-cli/releases/latest/download/connect-iq-sdk-manager-cli_$(curl -s https://api.github.com/repos/lindell/connect-iq-sdk-manager-cli/releases/latest | grep -oP '"tag_name": "v\K[^"]+')_Linux_x86_64.tar.gz"
tar -xzf /tmp/ciq-cli.tar.gz -C /tmp connect-iq-sdk-manager
mv /tmp/connect-iq-sdk-manager ~/.local/bin/
chmod +x ~/.local/bin/connect-iq-sdk-manager
# make sure ~/.local/bin is on PATH (add to ~/.bashrc if not already)

# 3. Accept Garmin's license, log in (opens browser for SSO), download SDK + device + fonts
connect-iq-sdk-manager agreement accept
connect-iq-sdk-manager login          # <- interactive, opens a browser
connect-iq-sdk-manager sdk set "*"    # picks latest SDK version
connect-iq-sdk-manager device download -d vivoactive5 -F   # -F = include fonts, required!

# 4. Generate a developer signing key (one-time, only needed once ever)
mkdir -p ~/.Garmin/ConnectIQ/keys
openssl genrsa -out ~/.Garmin/ConnectIQ/keys/developer_key.pem 4096
openssl pkcs8 -topk8 -inform PEM -outform DER \
  -in ~/.Garmin/ConnectIQ/keys/developer_key.pem \
  -out ~/.Garmin/ConnectIQ/keys/developer_key.der -nocrypt

# 5. Working Simulator AppImage (Garmin's bundled one is broken, see note above)
mkdir -p ~/.Garmin/ConnectIQ/AppImages
CIQ_VERSION=$(basename "$(cat ~/.Garmin/ConnectIQ/current-sdk.cfg)" | grep -oP '^connectiq-sdk-lin-\K[0-9]+\.[0-9]+\.[0-9]+')
ASSET_NAME=$(curl -s https://api.github.com/repos/pcolby/connectiq-sdk-manager/releases/tags/v0.6.10 \
  | grep -oP "\"name\": \"\KConnect_IQ_Simulator-${CIQ_VERSION}\+[0-9]+-x86_64\.AppImage(?=\")")
if [ -z "$ASSET_NAME" ]; then
  echo "Could not find a Simulator AppImage matching Connect IQ version $CIQ_VERSION."
  echo "Check https://github.com/pcolby/connectiq-sdk-manager/releases for the right asset."
  exit 1
fi
curl -Ls -o ~/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage \
  "https://github.com/pcolby/connectiq-sdk-manager/releases/download/v0.6.10/${ASSET_NAME}"
file ~/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage | grep -q ELF || {
  echo "Download failed - AppImage is not a valid ELF binary. Check the URL/asset name above."
  exit 1
}
chmod +x ~/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage

# 6. Replace the SDK's broken `simulator` binary with a wrapper around the working
#    AppImage, so VS Code's Ctrl+F5 auto-launches it like it's supposed to.
#    IMPORTANT: this must be idempotent (reuse an already-running instance) —
#    an earlier "kill then relaunch every time" version caused the simulator to
#    get stomped on every single build. Do not change this back to kill-first.
SDK_PATH=$(cat ~/.Garmin/ConnectIQ/current-sdk.cfg)
mv "$SDK_PATH/bin/simulator" "$SDK_PATH/bin/simulator.broken" 2>/dev/null || true
cat > "$SDK_PATH/bin/simulator" <<'WRAPPER'
#!/bin/bash
# VS Code's extension host (see note below) can exec this with PATH
# completely empty, which breaks the `timeout`/`bash` lookups inside
# already_up() below (making it wrongly think nothing's running) and
# fusermount resolution for the AppImage's own FUSE mount. Guarantee the
# standard system dirs are present regardless of what the caller passed.
export PATH="$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# Reuse an already-running simulator instead of killing/restarting it.
# (Used to read the first 20 bytes of a probe connection and grep for
# "garmin device" - but that text starts at byte offset 28 in the real
# handshake, after a fixed binary header, so it could NEVER match. It went
# unnoticed because run-sim.sh's own separate port check normally prevents
# this function from running at all when something's already listening -
# but VS Code's Monkey C extension calls this wrapper directly with no such
# pre-check, so every F5 hit this bug and forced a redundant relaunch
# attempt against an already-healthy simulator. A plain port check is both
# simpler and immune to any future change in the handshake's exact bytes.)
already_up() {
    ss -tln 2>/dev/null | grep -q ':1234 '
}
if already_up; then
    exit 0
fi

export NO_AT_BRIDGE=1   # avoids a GTK accessibility-bridge crash under Wayland

# VS Code's Monkey C extension launches this wrapper directly from the
# extension host process (not a terminal), and when VS Code itself was
# started from a desktop/dock icon rather than a shell, that process has
# NO DISPLAY/WAYLAND_DISPLAY at all (confirmed via /proc/<pid>/environ) -
# the GTK-based AppImage then crash-loops trying to open its window
# ("failed to create GtkMessageDialog") and never binds port 1234, so VS
# Code times out after 40s with "Unable to connect to simulator." Backfill
# from the systemd --user session (which does have them) if missing.
: "${XDG_RUNTIME_DIR:=/run/user/$(id -u)}"
export XDG_RUNTIME_DIR
if [ -z "$DISPLAY" ] || [ -z "$WAYLAND_DISPLAY" ] || [ -z "$XAUTHORITY" ]; then
    # systemctl --user itself needs XDG_RUNTIME_DIR to reach the bus, which
    # is why that's backfilled unconditionally above first. XAUTHORITY is
    # required too - this session's XWayland auth cookie lives in a
    # Mutter-managed file under XDG_RUNTIME_DIR, not the classic
    # ~/.Xauthority, so without it X11 clients get "Authorization required,
    # but no authorization protocol specified" even with DISPLAY set right.
    eval "$(systemctl --user show-environment 2>/dev/null | grep -E '^(DISPLAY|WAYLAND_DISPLAY|XAUTHORITY)=')"
    export DISPLAY WAYLAND_DISPLAY XAUTHORITY
fi

APPIMAGE="$HOME/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage"

# Also retry a couple of times in case the FUSE mount itself ever races
# ("Cannot mount AppImage, please check your FUSE setup") - separate from
# the DISPLAY issue above, this one really is an occasional race.
for attempt in 1 2 3; do
    "$APPIMAGE" "$@" &
    PID=$!
    for i in $(seq 1 20); do
        sleep 0.5
        if already_up; then
            wait "$PID" 2>/dev/null
            exit 0
        fi
        if ! kill -0 "$PID" 2>/dev/null; then
            break
        fi
    done
done
exit 1
WRAPPER
chmod +x "$SDK_PATH/bin/simulator"

# 7. Run the simulator as a systemd --user service that restarts itself
#    automatically. This is the actual fix for "unable to connect to
#    simulator" recurring: launching it only on-demand from VS Code's build
#    step means if it ever dies between builds, nothing brings it back until
#    the next Ctrl+F5 fails. A supervised service is always there instead.
mkdir -p ~/.config/systemd/user
cat > ~/.config/systemd/user/ciq-simulator.service <<'EOF'
[Unit]
Description=Connect IQ Simulator (community AppImage build, kept alive persistently)

[Service]
ExecStart=%h/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage
Environment=NO_AT_BRIDGE=1
Environment=DISPLAY=:0
Environment=WAYLAND_DISPLAY=wayland-0
Restart=always
RestartSec=2
StartLimitIntervalSec=60
StartLimitBurst=10

[Install]
WantedBy=default.target
EOF
systemctl --user daemon-reload
systemctl --user enable --now ciq-simulator.service

# 8. A manual fallback you can run yourself anytime, from any terminal, to
#    force a fresh restart of the service.
if ! grep -q "^ciq-sim()" ~/.bashrc 2>/dev/null; then
cat >> ~/.bashrc <<'BASHRC'

# Connect IQ Simulator helper - the simulator runs as a systemd --user
# service (ciq-simulator.service) that restarts itself automatically, so
# this just asks systemd to restart it rather than managing the process.
ciq-sim() {
    systemctl --user restart ciq-simulator.service
    sleep 2
    if systemctl --user is-active --quiet ciq-simulator.service; then
        echo "Simulator running. Leave it alone and go back to VS Code."
    else
        echo "Failed to start. Check: systemctl --user status ciq-simulator.service"
    fi
}
BASHRC
fi

echo "Done. Open this project folder in VS Code, make sure only garmin.monkey-c"
echo "extension is installed (not ghisguth.monkey-c), and press Ctrl+F5."
echo "The simulator runs as a systemd service and restarts itself automatically."
echo "If it ever misbehaves anyway, run 'ciq-sim' in a new terminal."
