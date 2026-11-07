#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# keyd is Linux-only; nothing to do on other platforms.
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "keyd is Linux-only; skipping on this platform."
    exit 0
fi

confirm "$(basename "$0" .sh)" || exit 0

echo "Uninstalling keyd..."

# Stop and disable the service first
if command -v systemctl >/dev/null 2>&1; then
    sudo systemctl disable --now keyd 2>/dev/null || echo "keyd service not running."
fi

# keyd is stowed to the system root (/) with sudo, so unstow the same way
if command -v stow >/dev/null 2>&1; then
    echo "Unstowing keyd configuration from /..."
    cd "$SCRIPT_DIR/.."
    sudo stow -v -D --target=/ keyd 2>/dev/null || echo "keyd not stowed or already unstowed"
fi

# Remove the keyd package
remove_package keyd

echo "keyd uninstalled successfully!"
