#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

if have_command ghostty; then
    echo "ghostty already installed."
    exit 0
fi

if command -v brew >/dev/null 2>&1; then
    if ! brew list --cask ghostty >/dev/null 2>&1; then
        brew install --cask ghostty
    else
        echo "ghostty already installed via Homebrew cask."
    fi
elif command -v pacman >/dev/null 2>&1; then
    ensure_command ghostty
else
    echo "ghostty is not available through the detected package manager. Install it manually from https://ghostty.org." >&2
fi
