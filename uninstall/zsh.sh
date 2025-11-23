#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling zsh..."

# Remove zsh using package manager
remove_package zsh

# Remove config files
unstow_config zsh
unstow_config p10k

echo "zsh uninstalled successfully!"