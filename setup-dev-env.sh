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
SDK_VERSION=$(basename "$(cat ~/.Garmin/ConnectIQ/current-sdk.cfg)")
curl -Ls -o ~/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage \
  "https://github.com/pcolby/connectiq-sdk-manager/releases/download/v0.6.10/Connect_IQ_Simulator-${SDK_VERSION#connectiq-sdk-lin-}-x86_64.AppImage"
# ^ if this 404s, check https://github.com/pcolby/connectiq-sdk-manager/releases
#   for the AppImage matching your installed SDK version and adjust the URL.
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
# Reuse an already-running simulator instead of killing/restarting it.
already_up() {
    timeout 1 bash -c 'exec 3<>/dev/tcp/127.0.0.1/1234 && head -c 20 <&3' 2>/dev/null | grep -q "garmin device"
}
if already_up; then
    exit 0
fi

export NO_AT_BRIDGE=1   # avoids a GTK accessibility-bridge crash under Wayland
APPIMAGE="$HOME/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage"

# AppImage's FUSE mount occasionally races and fails on first try
# ("Cannot mount AppImage, please check your FUSE setup") even though FUSE
# itself is fine - retry a couple of times before giving up.
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
