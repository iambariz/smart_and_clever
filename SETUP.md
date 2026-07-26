# Dev Environment Setup — smart_and_clever (Garmin Connect IQ Watch Face)

This is a Garmin Connect IQ watch face written in Monkey C, targeting the
**vivoactive5**. This doc covers getting a fully working dev environment on
Ubuntu, starting from literally nothing.

**Why this doc exists:** on modern Ubuntu (24.04+), Garmin's own Linux tools
are broken. Both the official SDK Manager and the official Simulator are
linked against `libwebkit2gtk-4.0`, which Ubuntu no longer ships. They just
open and silently do nothing — no error, no crash, nothing. Everything below
routes around that with community tools instead of Garmin's installers.

---

## TL;DR

```bash
bash setup-dev-env.sh
```

Handles everything except the interactive Garmin login (it'll pause and open
a browser for that). Read the rest of this doc if it fails partway, or you
want to understand what it's actually doing.

---

## 1. VS Code

Not included in the script — install it however you normally would:

- **apt (Microsoft's repo, recommended):**
  ```bash
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
  sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo apt update && sudo apt install code
  ```
- **Or download the `.deb` directly:** https://code.visualstudio.com/download
- **Or via snap:** `sudo snap install code --classic`

Then install the Monkey C extension:

```bash
code --install-extension garmin.monkey-c
```

If `ghisguth.monkey-c` (an unofficial, unrelated extension with a similar
name) is also installed, remove it — the two conflict:
```bash
code --uninstall-extension ghisguth.monkey-c
```

---

## 2. Java

Required by the Connect IQ compiler.

```bash
sudo apt update && sudo apt install -y openjdk-17-jre
java -version   # sanity check
```

---

## 3. The Connect IQ SDK (via community CLI, not Garmin's broken GUI)

Garmin's official SDK Manager GUI won't launch on modern Ubuntu (see intro).
Use **[connect-iq-sdk-manager-cli](https://github.com/lindell/connect-iq-sdk-manager-cli)**
instead — a community CLI that talks to the same Garmin backend.

```bash
# Install
mkdir -p ~/.local/bin
VERSION=$(curl -s https://api.github.com/repos/lindell/connect-iq-sdk-manager-cli/releases/latest | grep -oP '"tag_name": "v\K[^"]+')
curl -Ls -o /tmp/ciq-cli.tar.gz "https://github.com/lindell/connect-iq-sdk-manager-cli/releases/download/v${VERSION}/connect-iq-sdk-manager-cli_${VERSION}_Linux_x86_64.tar.gz"
tar -xzf /tmp/ciq-cli.tar.gz -C /tmp connect-iq-sdk-manager
mv /tmp/connect-iq-sdk-manager ~/.local/bin/
chmod +x ~/.local/bin/connect-iq-sdk-manager
```

Make sure `~/.local/bin` is on your `PATH` (check `.bashrc`/`.profile`).

```bash
# Accept Garmin's license
connect-iq-sdk-manager agreement accept

# Log in — this opens a browser for Garmin SSO. Must be run by a human.
connect-iq-sdk-manager login

# Download the latest SDK and set it as active
connect-iq-sdk-manager sdk set "*"

# Download device support for vivoactive5, INCLUDING FONTS
connect-iq-sdk-manager device download -d vivoactive5 -F
```

> ⚠️ **The `-F` flag is not optional.** Without it, device fonts aren't
> downloaded, and the app will crash at runtime the first time it draws text:
> `Error: Invalid Font Specified`.

Everything lands under `~/.Garmin/ConnectIQ/`:
- `Sdks/` — the SDK itself (compiler, simulator binaries, API docs)
- `Devices/` — device data for vivoactive5
- `Fonts/` — device font glyphs
- `current-sdk.cfg` — which SDK version is active (also read by VS Code)

---

## 4. Developer signing key

`monkeyc` (the compiler) refuses to build without a signing key. One-time
setup, generated locally with `openssl` — no download needed:

```bash
mkdir -p ~/.Garmin/ConnectIQ/keys
openssl genrsa -out ~/.Garmin/ConnectIQ/keys/developer_key.pem 4096
openssl pkcs8 -topk8 -inform PEM -outform DER \
  -in ~/.Garmin/ConnectIQ/keys/developer_key.pem \
  -out ~/.Garmin/ConnectIQ/keys/developer_key.der -nocrypt
```

Point VS Code at it via `.vscode/settings.json` in this repo (gitignored, so
recreate it if missing):

```json
{ "monkeyC.developerKeyPath": "/home/<you>/.Garmin/ConnectIQ/keys/developer_key.der" }
```

---

## 5. A working Simulator (Garmin's bundled one is broken)

The SDK you just downloaded includes `Sdks/<version>/bin/simulator`, but it's
linked against the same missing `libwebkit2gtk-4.0` — running it does
nothing.

Fix: swap in a community-rebuilt Simulator binary from
**[pcolby/connectiq-sdk-manager](https://github.com/pcolby/connectiq-sdk-manager)**
(same official Garmin binary, just with the missing libs bundled in), then
wrap it so VS Code can still auto-launch it via the normal `bin/simulator`
path.

```bash
# Download the AppImage matching your installed SDK version.
# Browse https://github.com/pcolby/connectiq-sdk-manager/releases and grab
# Connect_IQ_Simulator-<your-sdk-version>-x86_64.AppImage
mkdir -p ~/.Garmin/ConnectIQ/AppImages
curl -Ls -o ~/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage \
  "https://github.com/pcolby/connectiq-sdk-manager/releases/download/<tag>/Connect_IQ_Simulator-<version>-x86_64.AppImage"
chmod +x ~/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage

# Replace the SDK's broken simulator binary with a wrapper around it
SDK_PATH=$(cat ~/.Garmin/ConnectIQ/current-sdk.cfg)
mv "$SDK_PATH/bin/simulator" "$SDK_PATH/bin/simulator.broken"
cat > "$SDK_PATH/bin/simulator" <<'EOF'
#!/bin/bash
# Reuse an already-running simulator instead of killing/restarting it.
already_up() {
    timeout 1 bash -c 'exec 3<>/dev/tcp/127.0.0.1/1234 && head -c 20 <&3' 2>/dev/null | grep -q "garmin device"
}
if already_up; then
    exit 0
fi
export NO_AT_BRIDGE=1
exec "$HOME/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage" "$@"
EOF
chmod +x "$SDK_PATH/bin/simulator"
```

**Why the wrapper checks `already_up` first:** an earlier version
unconditionally killed and restarted the simulator on every invocation. VS
Code invokes `bin/simulator` on every Ctrl+F5, so that killed a
perfectly-working instance every single build, causing constant "unable to
connect" errors. Checking port 1234 first and only launching if nothing's
there fixed it. **Do not revert this to kill-first.**

**Why `NO_AT_BRIDGE=1`:** without it, the simulator crashes ~25-30 seconds
after launch with an `atk-bridge` warning followed by exit — a known
GTK-under-Wayland accessibility-bus bug.

### Manual fallback: `ciq-sim`

For when the simulator ever gets stuck anyway, add this to `~/.bashrc`:

```bash
ciq-sim() {
    pkill -9 -f "AppRun.wrapped" 2>/dev/null
    sleep 1
    NO_AT_BRIDGE=1 nohup ~/.Garmin/ConnectIQ/AppImages/Connect_IQ_Simulator.AppImage >/tmp/ciq-simulator.log 2>&1 &
    disown
    sleep 2
    if pgrep -f "AppRun.wrapped" >/dev/null; then
        echo "Simulator running."
    else
        echo "Failed to start. Check /tmp/ciq-simulator.log"
    fi
}
```

Then `source ~/.bashrc` (or open a new terminal), and run `ciq-sim` any time
things seem stuck. This one force-restarts unconditionally — that's fine
since it's opt-in/manual, unlike the wrapper VS Code invokes automatically.

---

## 6. The launcher icon

`resources/drawables/launcher_icon.png` must be **56×56** for vivoactive5.
If you ever replace it, resize to exactly that (Garmin scales anything else
but complains with a build warning). No PNG editor needed — Python's
Pillow can do it:

```bash
python3 -c "
from PIL import Image
img = Image.open('resources/drawables/launcher_icon.png')
img.resize((56, 56), Image.LANCZOS).save('resources/drawables/launcher_icon.png')
"
```

(`pip install pillow` first if it's not already available.)

---

## 7. Actually building and running

1. Open this project folder in VS Code.
2. Click into a `.mc` file (e.g. `source/smartAndCleverView.mc`) so it's the
   focused editor tab — **Ctrl+F5 runs whatever file type is currently
   focused**, so if a shell script or Markdown file is focused instead,
   VS Code errors instead of building.
3. Press **Ctrl+F5** (Run Without Debugging). This builds via `monkeyc` and
   auto-launches the simulator through the wrapper above.

---

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| "Unable to connect to simulator" | Simulator isn't running and didn't auto-launch. Run `ciq-sim` in a terminal, wait for "Simulator running.", then Ctrl+F5 again. |
| `Error: Invalid Font Specified` crash | Fonts weren't downloaded. Re-run `connect-iq-sdk-manager device download -d vivoactive5 -F`. |
| VS Code says no debugger for this file type | Wrong file is focused in the editor — click into a `.mc` source file first. |
| SDK Manager or Simulator GUI opens and does nothing | That's Garmin's broken official binary — use the CLI/AppImage workflow above, don't try to fix the official installer directly. |
| Build succeeds but nothing happens after | Check whether the simulator is actually running: `pgrep -f AppRun.wrapped`. If not, see the "unable to connect" row above. |
| Launcher icon size warning during build | See section 6 — resize `launcher_icon.png` to 56×56. |
