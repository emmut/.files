#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# OpenCode CLI (the stowed ~/.config/opencode config).
# The official installer works on both macOS and Linux.
if ! have_command opencode; then
    echo "Installing OpenCode..."
    curl -fsSL https://opencode.ai/install | bash
else
    echo "opencode already installed."
fi

# Ensure the install dir is on PATH for non-login shells. The installer puts
# the binary in $HOME/.opencode/bin by default.
if ! have_command opencode && [ -d "$HOME/.opencode/bin" ]; then
    export PATH="$HOME/.opencode/bin:$PATH"
fi
