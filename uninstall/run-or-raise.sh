#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling run-or-raise settings..."

# Remove optional emoji helper installed via paru on Arch-based systems.
if command -v pacman >/dev/null 2>&1 && pacman -Q wofi-emoji >/dev/null 2>&1; then
  if command -v paru >/dev/null 2>&1; then
    paru -Rns --noconfirm wofi-emoji || true
  else
    sudo pacman -Rns --noconfirm wofi-emoji || true
  fi
fi

# Reset window management shortcuts back to GNOME defaults.
gsettings reset org.gnome.mutter.keybindings toggle-tiled-left
gsettings reset org.gnome.mutter.keybindings toggle-tiled-right
gsettings reset org.gnome.desktop.wm.keybindings toggle-fullscreen
gsettings reset org.gnome.desktop.wm.keybindings toggle-maximized
gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-left
gsettings reset org.gnome.desktop.wm.keybindings move-to-workspace-right
gsettings reset org.gnome.desktop.wm.keybindings minimize

# Disable extension if present.
if command -v gnome-extensions >/dev/null 2>&1; then
  if gnome-extensions info run-or-raise@edvard.cz >/dev/null 2>&1; then
    gnome-extensions disable run-or-raise@edvard.cz || true
  fi
fi

# Remove config files from stow.
unstow_config run-or-raise

echo "run-or-raise settings removed and shortcuts reset."
