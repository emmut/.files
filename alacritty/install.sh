#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

if have_command alacritty; then
    echo "alacritty already installed."
else
    if command -v brew >/dev/null 2>&1; then
        if ! brew list --cask alacritty >/dev/null 2>&1; then
            brew install --cask alacritty
        else
            echo "alacritty already installed via Homebrew cask."
        fi
    else
        ensure_command alacritty
    fi
fi

if command -v fc-list >/dev/null 2>&1 && ! fc-list | grep -qi "FiraCode Nerd Font"; then
    echo "FiraCode Nerd Font Mono not detected. Install a Nerd Font for best results." >&2
fi
