#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command tmux

# Install TPM (Tmux Plugin Manager)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "TPM already installed."
fi

# Dependencies for the sesh session picker popup (see .tmux.conf).
# gum and sesh aren't in every distro's default repos, so treat them as best-effort.
if ! have_command gum; then
    ensure_command gum || echo "Could not install gum automatically; install it manually for the sesh popup."
fi

if ! have_command sesh; then
    if command -v brew >/dev/null 2>&1; then
        brew install sesh || echo "Could not install sesh via brew."
    elif command -v paru >/dev/null 2>&1; then
        paru -S --noconfirm sesh || echo "Could not install sesh via paru."
    elif command -v go >/dev/null 2>&1; then
        go install github.com/joshmedeski/sesh/v2@latest || echo "Could not install sesh via go."
    else
        echo "sesh not installed; see https://github.com/joshmedeski/sesh for the tmux session picker."
    fi
fi
