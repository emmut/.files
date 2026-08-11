#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# keyd is a Linux kernel-level key remapper; it has no macOS equivalent here.
if [[ "$(uname -s)" != "Linux" ]]; then
    echo "keyd is Linux-only; skipping on this platform."
    exit 0
fi

ensure_command keyd

if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl enable --now keyd
fi
