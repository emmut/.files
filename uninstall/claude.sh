#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling claude..."

# Claude Code is installed via its official installer, not a package manager.
if [ -d "$HOME/.local/share/claude" ]; then
    rm -rf "$HOME/.local/share/claude"
fi
rm -f "$HOME/.local/bin/claude"

# Remove config files
unstow_config claude

echo "claude uninstalled successfully!"
