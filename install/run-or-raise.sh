#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# run-or-raise wires up GNOME (Mutter) keybindings; skip where GNOME/gsettings
# is unavailable, including macOS and non-GNOME Linux desktops.
if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings not found; skipping run-or-raise (GNOME only)."
    exit 0
fi

ensure_command gsettings glib2

if command -v pacman >/dev/null 2>&1; then
  ensure_command wl-copy wl-clipboard

  # wofi-emoji is AUR-only; paru itself is not in vanilla Arch repos, so
  # treat both as optional rather than failing the whole install.
  if have_command paru; then
    if ! have_command wofi-emoji; then
      paru -S --noconfirm wofi-emoji || echo "Could not install wofi-emoji; the emoji shortcut won't work."
    else
      echo "wofi-emoji already installed."
    fi
  else
    echo "paru not found; skipping wofi-emoji (AUR). Install paru and re-run for the emoji picker."
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

# Install the extension from extensions.gnome.org if missing, then (re)enable it.
UUID="run-or-raise@edvard.cz"
if command -v gnome-extensions >/dev/null 2>&1; then
  if gnome-extensions info "$UUID" >/dev/null 2>&1; then
    gnome-extensions disable "$UUID" || true
    gnome-extensions enable "$UUID" || true
  else
    echo "Installing $UUID from extensions.gnome.org..."
    SHELL_VERSION="$(gnome-shell --version | grep -oE '[0-9]+' | head -1)"
    DOWNLOAD_PATH="$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=$UUID&shell_version=$SHELL_VERSION" \
      | grep -oE '"download_url": *"[^"]+"' | cut -d'"' -f4 || true)"
    if [ -n "$DOWNLOAD_PATH" ]; then
      # mktemp --suffix is GNU-only; use a temp dir so this stays portable.
      TMP_DIR="$(mktemp -d)"
      TMP_ZIP="$TMP_DIR/extension.zip"
      curl -fsSL "https://extensions.gnome.org$DOWNLOAD_PATH" -o "$TMP_ZIP"
      gnome-extensions install --force "$TMP_ZIP"
      rm -rf "$TMP_DIR"
      # Newly installed extensions can't be enabled until GNOME Shell reloads.
      gnome-extensions enable "$UUID" 2>/dev/null \
        || echo "Extension installed. Log out and back in, then run: gnome-extensions enable $UUID"
    else
      echo "No $UUID build found for GNOME Shell $SHELL_VERSION; install it via Extension Manager."
    fi
  fi
fi
