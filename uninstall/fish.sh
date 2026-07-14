#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Removing the shell (or the starship prompt it runs) out from under the
# current session breaks it.
if ancestor_process fish; then
    abort_in_use fish "this script is running inside a fish session"
fi
if [ -n "${STARSHIP_SHELL:-}" ]; then
    abort_in_use starship "this shell's prompt is powered by starship (fish uninstall removes it too)"
fi

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

# Remove bun (also removes the bun-global @antfu/ni that provides nr)
echo "Removing bun..."
rm -rf "$HOME/.bun"

# Remove cheat script
echo "Removing cheat script..."
rm -f "$HOME/.local/bin/cheat"

# Remove uv and opencode (install/fish.sh installs both via their
# official installers; cursor comes from the system package manager,
# so it is left alone here)
echo "Removing uv..."
rm -f "$HOME/.local/bin/uv" "$HOME/.local/bin/uvx"
echo "Removing opencode..."
rm -rf "$HOME/.opencode"
rm -f "$HOME/.local/bin/opencode"

# Remove fish plugins and fisher
echo "Removing fish plugins..."
if command -v fish >/dev/null 2>&1; then
    fish -c 'fisher list | xargs -I {} fisher uninstall {}' 2>/dev/null || true
    fish -c 'functions -e fisher' 2>/dev/null || true
fi

# Remove fish config
unstow_config fish

echo "fish and related tools uninstalled successfully!"