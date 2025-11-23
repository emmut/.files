#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling alacritty..."

# Remove alacritty using package manager
remove_package alacritty

# Remove config files
unstow_config alacritty

echo "alacritty uninstalled successfully!"