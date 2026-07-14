#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command lazygit

# The lazygit config uses delta as its pager, with the Catppuccin Mocha
# syntax theme that delta reads from bat's theme cache.
if ! have_command delta; then
    ensure_command delta git-delta
fi
ensure_command bat

# bat is installed as batcat on Debian/Ubuntu
BAT_CMD=bat
have_command bat || BAT_CMD=batcat

# The theme files live in the bat stow package; link them and rebuild the
# cache so delta can find "Catppuccin Mocha".
(
    cd "$SCRIPT_DIR/.."
    BEFORE=$(git status --porcelain -- bat delta)
    stow -R --adopt --target="$HOME" bat delta
    restore_adopted "$BEFORE" bat delta
)
if ! "$BAT_CMD" --list-themes 2>/dev/null | grep -q "Catppuccin Mocha"; then
    "$BAT_CMD" cache --build
fi
