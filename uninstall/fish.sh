#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh) and all related tools" || exit 0

echo "Uninstalling fish and related tools..."

# Remove fish shell and related packages
remove_package fish
remove_package starship
remove_package zoxide
remove_package fzf
remove_package vivid
remove_package lsd
remove_package trash-cli

# Remove fnm
echo "Removing fnm..."
rm -rf "$HOME/.fnm"

# Remove cheat script
echo "Removing cheat script..."
rm -f "$HOME/.local/bin/cheat"

# Remove fish plugins and fisher
echo "Removing fish plugins..."
if command -v fish >/dev/null 2>&1; then
    fish -c 'fisher list | xargs -I {} fisher uninstall {}' 2>/dev/null || true
    fish -c 'functions -e fisher' 2>/dev/null || true
fi

# Remove fish config
unstow_config fish

echo "fish and related tools uninstalled successfully!"