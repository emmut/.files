#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling Zed..."

# Remove Zed using package manager
remove_package zed

# Remove config files
unstow_config zed

echo "Zed uninstalled successfully!"