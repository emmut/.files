#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../scripts/utils.sh"

# Core shells + helpers
ensure_command fish
ensure_command starship
ensure_command zoxide
ensure_command fzf
ensure_command vivid
ensure_command curl
ensure_command git
ensure_command trash-cli
ensure_command lsd
# killport uses lsof to find processes by port
ensure_command lsof

# Install fnm if missing (package managers rarely ship it)
if ! have_command fnm; then
    echo "Installing fnm (Fast Node Manager)..."
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.fnm" --skip-shell
else
    echo "fnm already installed."
fi

# Install latest LTS Node.js if no Node is installed
if ! have_command node; then
    echo "Installing latest LTS Node.js..."
    export PATH="$HOME/.fnm:$PATH"
    if command -v fnm >/dev/null 2>&1; then
        fnm install --lts
        echo "Node.js $(node --version) installed successfully!"
    else
        echo "Error: fnm command not found after installation"
    fi
else
    echo "Node.js $(node --version) is already installed"
fi

# Install bun if missing (package managers rarely ship it)
if ! have_command bun; then
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "bun already installed."
fi

# Make a freshly installed bun available for the rest of this script
if [ -d "$HOME/.bun/bin" ]; then
    export PATH="$HOME/.bun/bin:$PATH"
fi

# Install @antfu/ni (provides the `nr` command) if missing
if ! have_command nr; then
    echo "Installing @antfu/ni (provides nr)..."
    if have_command bun; then
        bun add -g @antfu/ni
    else
        echo "Error: bun not found; cannot install @antfu/ni." >&2
    fi
else
    echo "nr already installed."
fi

# Install uv if missing (conf.d/uv.env.fish sources its env file).
# The official installer creates ~/.local/bin/env.fish on macOS and Linux.
if ! have_command uv; then
    echo "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
else
    echo "uv already installed."
fi

# Install opencode if missing (the `oo` alias). The official installer
# works on both macOS and Linux.
if ! have_command opencode; then
    if command -v brew >/dev/null 2>&1; then
        brew install sst/tap/opencode || echo "Could not install opencode via brew."
    else
        echo "Installing opencode..."
        curl -fsSL https://opencode.ai/install | bash
    fi
else
    echo "opencode already installed."
fi

# Install cursor if missing (the `c` alias). GUI editor: Homebrew cask on
# macOS, AUR on Arch; no repo package on Debian/Ubuntu.
if ! have_command cursor; then
    if command -v brew >/dev/null 2>&1; then
        brew install --cask cursor || echo "Could not install cursor via brew."
    elif command -v paru >/dev/null 2>&1; then
        paru -S --noconfirm cursor-bin || echo "Could not install cursor via paru."
    else
        echo "cursor not installed; download it from https://cursor.com/downloads."
    fi
else
    echo "cursor already installed."
fi

# Install cheat if missing
if [[ ! -f "$HOME/.local/bin/cheat" ]]; then
    echo "Installing cheat..."
    mkdir -p "$HOME/.local/bin"
    curl -sSL https://cht.sh/:cht.sh > "$HOME/.local/bin/cheat"
    chmod +x "$HOME/.local/bin/cheat"
else
    echo "cheat already installed."
fi

# Ensure fisher is available
if ! fish -c 'functions -q fisher' >/dev/null 2>&1; then
    echo "Installing fisher (fish plugin manager)..."
    curl -sL https://git.io/fisher | fish -c 'source && fisher install jorgebucaran/fisher'
else
    echo "fisher already installed."
fi

# Install required plugins
if ! fish -c 'fisher list | grep -q "jhillyerd/plugin-git"' >/dev/null 2>&1; then
    fish -c 'fisher install jhillyerd/plugin-git'
else
    echo "jhillyerd/plugin-git already installed via fisher."
fi

if ! fish -c 'fisher list | grep -q "franciscolourenco/done"' >/dev/null 2>&1; then
    fish -c 'fisher install franciscolourenco/done'
else
    echo "franciscolourenco/done already installed via fisher."
fi
