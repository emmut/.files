#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Don't remove nvim from inside an nvim :terminal.
if [ -n "${NVIM:-}" ]; then
    abort_in_use neovim "this script is running inside an nvim terminal"
fi

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling neovim..."

# Remove neovim using the package manager
remove_package neovim

# Remove config files
unstow_config nvim

echo "neovim uninstalled successfully!"
