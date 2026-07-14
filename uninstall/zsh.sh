#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling zsh..."

# Remove zsh using package manager
remove_package zsh

# Remove Oh My Zsh and the plugins install/zsh.sh cloned into it
echo "Removing Oh My Zsh..."
rm -rf "$HOME/.oh-my-zsh"

# Remove config files (p10k is handled by uninstall/p10k.sh)
unstow_config zsh

echo "zsh uninstalled successfully!"