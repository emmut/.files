#!/bin/bash

# Source the utility script to get the install_packages function
source "$(dirname "$0")/../scripts/utils.sh"

# Install zsh and other dependencies
install_packages zsh zsh-autosuggestions zsh-syntax-highlighting fzf vivid zoxide neovim

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install fast-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting" ]; then
    echo "Installing fast-syntax-highlighting..."
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
      "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting"
else
    echo "fast-syntax-highlighting is already installed."
fi

# Install zsh-fzf-history-search
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search" ]; then
    echo "Installing zsh-fzf-history-search..."
    git clone https://github.com/joshskidmore/zsh-fzf-history-search \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search"
else
    echo "zsh-fzf-history-search is already installed."
fi

