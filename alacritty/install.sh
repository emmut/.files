#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command alacritty

if command -v fc-list >/dev/null 2>&1 && ! fc-list | grep -qi "FiraCode Nerd Font"; then
    echo "FiraCode Nerd Font Mono not detected. Install a Nerd Font for best results." >&2
fi
