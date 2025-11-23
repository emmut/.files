#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

if have_command zed; then
    echo "Zed already installed."
    exit 0
fi

if command -v brew >/dev/null 2>&1; then
    if ! brew list --cask zed >/dev/null 2>&1; then
        brew install --cask zed
    else
        echo "Zed already installed via Homebrew cask."
    fi
elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm --needed zed-editor
else
    echo "Zed is not available through the detected package manager. Install it manually from https://zed.dev." >&2
fi
