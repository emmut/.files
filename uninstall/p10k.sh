#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling powerlevel10k..."

# Remove the cloned Oh My Zsh theme
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
echo "Removing powerlevel10k theme..."
rm -rf "$THEME_DIR"

# Remove config files
unstow_config p10k

echo "powerlevel10k uninstalled successfully!"
