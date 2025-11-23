#!/bin/bash

# Source the utility script to get the install_packages function
source "$(dirname "$0")/../scripts/utils.sh"

install_packages tmux

# Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM is already installed."
fi

