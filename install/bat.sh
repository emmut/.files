#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command bat

# bat is installed as batcat on Debian/Ubuntu
BAT_CMD=bat
have_command bat || BAT_CMD=batcat

# The bat config uses a Catppuccin theme; link the theme files and rebuild
# the cache so bat (and delta) can find them.
(cd "$SCRIPT_DIR/.." && stow -R --adopt bat)
if ! "$BAT_CMD" --list-themes 2>/dev/null | grep -q "Catppuccin"; then
    "$BAT_CMD" cache --build
fi
