#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Don't remove the terminal this session is running in.
if [ "${TERM_PROGRAM:-}" = "ghostty" ] || [ -n "${GHOSTTY_RESOURCES_DIR:-}" ]; then
    abort_in_use ghostty "this script is running inside a ghostty window"
fi

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling ghostty..."

# Remove ghostty using package manager
remove_package ghostty

# Remove config files
unstow_config ghostty

echo "ghostty uninstalled successfully!"