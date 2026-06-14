#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

if have_command zed; then
    echo "zed already installed."
    exit 0
fi

if command -v brew >/dev/null 2>&1; then
    # macOS / Linuxbrew: install the cask.
    if brew list --cask zed >/dev/null 2>&1; then
        echo "zed already installed via Homebrew cask."
    else
        brew install --cask zed
    fi
else
    # Linux: use Zed's official installer. The distro package (e.g. Arch `zed`)
    # pulls in a vulkan-driver dependency that can conflict with the installed
    # mesa (notably mesa-git on CachyOS); the official installer avoids that.
    echo "Installing Zed via the official installer..."
    curl -fsSL https://zed.dev/install.sh | sh
fi
