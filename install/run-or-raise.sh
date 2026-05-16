#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command gsettings glib2

if command -v pacman >/dev/null 2>&1; then
  ensure_command wl-copy wl-clipboard
  ensure_command paru paru

  if ! have_command wofi-emoji; then
    paru -S --noconfirm wofi-emoji
  else
    echo "wofi-emoji already installed."
  fi
fi

# Map GNOME window management shortcuts to Hyper (Caps -> C-A-S in keyd).
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Control><Alt><Shift>Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Control><Alt><Shift>Right']"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Control><Alt><Shift>Return', '<Control><Alt><Shift>KP_Enter']"
# Move focused window between workspaces without Super.
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-left "['<Control><Alt><Shift>j']"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-right "['<Control><Alt><Shift>k']"
# Switch workspaces without moving the focused window.
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Control><Alt><Shift>u']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Control><Alt><Shift>i']"
gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h']"

# Reload extension if it is installed.
if command -v gnome-extensions >/dev/null 2>&1; then
  if gnome-extensions info run-or-raise@edvard.cz >/dev/null 2>&1; then
    gnome-extensions disable run-or-raise@edvard.cz || true
    gnome-extensions enable run-or-raise@edvard.cz || true
  else
    echo "run-or-raise@edvard.cz is not installed. Install it via Extension Manager."
  fi
fi
