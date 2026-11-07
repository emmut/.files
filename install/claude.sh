#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Claude Code CLI (the `cc` fish alias and the stowed ~/.claude config).
# The official installer works on both macOS and Linux.
if ! have_command claude; then
    echo "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
else
    echo "claude already installed."
fi

# notify.sh uses osascript on macOS and notify-send on Linux.
if [[ "$(uname -s)" == "Linux" ]] && ! have_command notify-send; then
    if command -v apt-get >/dev/null 2>&1; then
        install_packages libnotify-bin
    else
        install_packages libnotify
    fi
fi
