#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command gsettings glib2

if command -v pacman >/dev/null 2>&1; then
  ensure_command paru paru

  if ! have_command wofi-emoji; then
    paru -S --noconfirm wofi-emoji
  else
    echo "wofi-emoji already installed."
  fi
fi

# Window management shortcuts on Hyper (Caps-hold -> Super via keyd).
gsettings set org.gnome.mutter.keybindings toggle-tiled-left "['<Super>Left']"
gsettings set org.gnome.mutter.keybindings toggle-tiled-right "['<Super>Right']"
gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Super>Return', '<Super>KP_Enter']"

# Reload extension if it is installed.
if command -v gnome-extensions >/dev/null 2>&1; then
  if gnome-extensions info run-or-raise@edvard.cz >/dev/null 2>&1; then
    gnome-extensions disable run-or-raise@edvard.cz || true
    gnome-extensions enable run-or-raise@edvard.cz || true
  else
    echo "run-or-raise@edvard.cz is not installed. Install it via Extension Manager."
  fi
fi
