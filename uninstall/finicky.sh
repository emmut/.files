#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling finicky..."

# Remove finicky (macOS-only, installed via Homebrew cask)
if command -v brew >/dev/null 2>&1; then
    brew uninstall --cask finicky 2>/dev/null || echo "finicky not found in Homebrew."
fi

# Remove config files
unstow_config finicky

echo "finicky uninstalled successfully!"
