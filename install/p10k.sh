#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command git

# powerlevel10k is loaded as an Oh My Zsh theme:
#   ZSH_THEME="powerlevel10k/powerlevel10k" (see zsh/.zshrc)
# The .p10k.zsh config is stowed separately; this clones the theme itself.
THEME_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$THEME_DIR" ]; then
    echo "Installing powerlevel10k theme..."
    mkdir -p "$(dirname "$THEME_DIR")"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$THEME_DIR"
else
    echo "powerlevel10k already installed."
fi
