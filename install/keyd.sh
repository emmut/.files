#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command keyd

if command -v systemctl >/dev/null 2>&1; then
  sudo systemctl enable --now keyd
fi
