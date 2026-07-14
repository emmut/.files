#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Finicky is a macOS-only browser router.
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "finicky is macOS-only; skipping on this platform."
    exit 0
fi

# Finicky is a .app with no CLI binary, so check the cask rather than a command.
if command -v brew >/dev/null 2>&1; then
    if ! brew list --cask finicky >/dev/null 2>&1; then
        brew install --cask finicky
    else
        echo "finicky already installed via Homebrew cask."
    fi
else
    echo "finicky requires Homebrew on macOS. Install it manually from https://github.com/johnste/finicky." >&2
fi
