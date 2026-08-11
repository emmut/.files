#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Don't remove the terminal this session is running in.
if [ -n "${KITTY_WINDOW_ID:-}" ] || [ "${TERM:-}" = "xterm-kitty" ]; then
    abort_in_use kitty "this script is running inside a kitty window"
fi

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling kitty..."

# Remove kitty using package manager
remove_package kitty

# Remove config files
unstow_config kitty

echo "kitty uninstalled successfully!"