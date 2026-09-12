#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Install mise if not present
if ! have_command mise; then
    echo "Installing mise..."
    curl https://mise.run | sh
    # mise installs to ~/.local/bin/mise by default
    export PATH="$HOME/.local/bin:$PATH"
fi

# Verify mise is available
if ! have_command mise; then
    echo "mise installation failed"
    exit 1
fi

echo "mise installed: $(mise --version)"

# Stow the mise configuration
(
    cd "$SCRIPT_DIR/.."
    BEFORE=$(git status --porcelain -- mise)
    stow -R --adopt --target="$HOME" mise
    restore_adopted "$BEFORE" mise
)

# Install tools from mise.toml if it exists
if [ -f "$HOME/.config/mise/config.toml" ]; then
    echo "Installing tools from mise config..."
    mise install
fi