#!/bin/sh
set -e

# Runs before chezmoi reads the source state (see .chezmoi.toml.tmpl), so the
# Dashlane CLI is available to templates. Runs on every chezmoi command, so it
# exits immediately once dcli is installed.

DCLI="$HOME/.local/bin/dcli"

[ -x "$DCLI" ] && exit 0

case "$(uname -s)-$(uname -m)" in
  Darwin-arm64)  asset="dcli-macos-arm64" ;;
  Darwin-x86_64) asset="dcli-macos-x64" ;;
  Linux-x86_64)  asset="dcli-linux-x64" ;;
  *)
    echo "[DOTFILES] Dashlane CLI isn't available for $(uname -sm), skipping" >&2
    exit 0
    ;;
esac

url="https://github.com/Dashlane/dashlane-cli/releases/latest/download/$asset"

echo "[DOTFILES] Installing Dashlane CLI"
mkdir -p "$HOME/.local/bin"

if command -v curl > /dev/null 2>&1; then
  curl -fsSL "$url" -o "$DCLI.tmp"
else
  wget -qO "$DCLI.tmp" "$url"
fi

chmod +x "$DCLI.tmp"
mv "$DCLI.tmp" "$DCLI"
