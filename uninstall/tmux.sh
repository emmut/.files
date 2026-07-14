#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling tmux..."

# Remove tmux using package manager
remove_package tmux

# Remove config files
echo "Removing tmux configuration..."
rm -f "$HOME/.tmux.conf"

# Remove TPM and the plugins it installed (install/tmux.sh sets these up)
echo "Removing TPM and tmux plugins..."
rm -rf "$HOME/.tmux"

echo "tmux uninstalled successfully!"