#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

ensure_command lazygit

# The lazygit config uses delta as its pager, with the Catppuccin Mocha
# syntax theme from bat's cache. delta and bat are declared as lazygit's
# package dependencies in scripts/setup.sh (package_deps), so they get
# installed and stowed whenever lazygit is selected.
