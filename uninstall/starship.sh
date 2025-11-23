#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling starship..."

# Remove starship using package manager
remove_package starship

# Remove config files
unstow_config starship

echo "starship uninstalled successfully!"