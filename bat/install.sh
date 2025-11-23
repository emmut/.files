#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

if have_command bat || have_command batcat; then
    echo "bat (or batcat) already installed."
else
    ensure_command bat
fi
