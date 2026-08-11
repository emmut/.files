#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNINSTALL_DIR="$SCRIPT_DIR/uninstall"

source "$SCRIPT_DIR/scripts/utils.sh"

echo "Uninstalling all tools..."

# Ask for the sudo password once up front instead of stalling mid-run.
prime_sudo

# Run each uninstall script in the uninstall directory
for script in "$UNINSTALL_DIR"/*.sh; do
    if [[ -f "$script" ]]; then
        script_name=$(basename "$script")
        echo "Running $script_name..."
        bash "$script"
        echo "---"
    fi
done

echo "All tools have been uninstalled!"