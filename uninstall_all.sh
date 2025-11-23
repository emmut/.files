#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
UNINSTALL_DIR="$SCRIPT_DIR/uninstall"

echo "Uninstalling all tools..."

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