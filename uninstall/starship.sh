#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# A live starship prompt crashes when the binary disappears under it.
if [ -n "${STARSHIP_SHELL:-}" ]; then
    abort_in_use starship "this shell's prompt is powered by starship"
fi

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling starship..."

# Remove starship using package manager
remove_package starship

# Remove config files
unstow_config starship

echo "starship uninstalled successfully!"