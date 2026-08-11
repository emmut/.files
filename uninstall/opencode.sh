#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling opencode..."

# OpenCode is installed via its official installer, not a package manager.
if [ -d "$HOME/.opencode" ]; then
    rm -rf "$HOME/.opencode"
fi

# Remove config files
unstow_config opencode

echo "opencode uninstalled successfully!"
