#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# The `neovim` package provides the `nvim` command.
ensure_command nvim neovim

# The nvim config (emmut/kickstart.nvim) is a git submodule; initialize it
# if the repo was cloned without --recurse-submodules.
REPO_ROOT="$SCRIPT_DIR/.."
if [ ! -f "$REPO_ROOT/nvim/.config/nvim/init.lua" ]; then
    echo "Initializing kickstart.nvim submodule..."
    git -C "$REPO_ROOT" submodule update --init nvim/.config/nvim
else
    echo "kickstart.nvim submodule already initialized."
fi

# kickstart.nvim dependencies: telescope uses ripgrep and fd, and
# treesitter/mason need make, gcc, and unzip to build parsers and tools.
ensure_command rg ripgrep
ensure_command make
ensure_command gcc
ensure_command unzip

# fd is packaged as fd-find on Debian/Ubuntu with a `fdfind` binary.
if ! have_command fd; then
    if command -v apt-get >/dev/null 2>&1; then
        install_packages fd-find
        mkdir -p "$HOME/.local/bin"
        ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    else
        ensure_command fd
    fi
else
    echo "fd already installed."
fi
