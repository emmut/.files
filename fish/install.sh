#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Core shells + helpers
ensure_command fish
ensure_command starship
ensure_command zoxide
ensure_command fzf
ensure_command vivid
ensure_command curl
ensure_command git
ensure_command trash-cli

# Install fnm if missing (package managers rarely ship it)
if ! have_command fnm; then
    echo "Installing fnm (Fast Node Manager)..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.fnm" --skip-shell
else
    echo "fnm already installed."
fi

# Install latest LTS Node.js if no Node is installed
if ! have_command node; then
    echo "Installing latest LTS Node.js..."
    export PATH="$HOME/.fnm:$PATH"
    if command -v fnm >/dev/null 2>&1; then
        fnm install --lts
        fnm use lts-latest
        echo "Node.js $(node --version) installed successfully!"
    else
        echo "Error: fnm command not found after installation"
    fi
else
    echo "Node.js $(node --version) is already installed"
fi

# Ensure fisher is available
if ! fish -c 'functions -q fisher' >/dev/null 2>&1; then
    echo "Installing fisher (fish plugin manager)..."
    curl -sL https://git.io/fisher | fish -c 'source && fisher install jorgebucaran/fisher'
else
    echo "fisher already installed."
fi

# Install required plugins
if ! fish -c 'fisher list | grep -q "jhillyerd/plugin-git"' >/dev/null 2>&1; then
    fish -c 'fisher install jhillyerd/plugin-git'
else
    echo "jhillyerd/plugin-git already installed via fisher."
fi
