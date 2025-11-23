#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

DEPS_DIR="$SCRIPT_DIR/../.deps"

install_deps() {
    local package=$1
    local deps_file="$DEPS_DIR/$package"
    
    if [[ -f "$deps_file" ]]; then
        echo "Installing dependencies for $package..."
        while read -r dep; do
            [[ -n "$dep" && ! "$dep" =~ ^# ]] && ensure_command "$dep"
        done < "$deps_file"
    else
        echo "No dependencies file found for $package"
    fi
}

# Special handling for packages with custom installation
install_custom() {
    local package=$1
    
    case "$package" in
        "fish")
            # Install fnm if missing
            if ! have_command fnm; then
                echo "Installing fnm (Fast Node Manager)..."
                curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.fnm" --skip-shell
            fi
            
            # Install latest LTS Node.js if no Node is installed
            if ! have_command node; then
                echo "Installing latest LTS Node.js..."
                export PATH="$HOME/.fnm:$PATH"
                if command -v fnm >/dev/null 2>&1; then
                    fnm install --lts
                    fnm use lts-latest
                fi
            fi
            
            # Install fisher and plugins
            if ! fish -c 'functions -q fisher' >/dev/null 2>&1; then
                echo "Installing fisher..."
                curl -sL https://git.io/fisher | fish -c 'source && fisher install jorgebucaran/fisher'
            fi
            
            fish -c 'fisher list | grep -q "jhillyerd/plugin-git"' || fish -c 'fisher install jhillyerd/plugin-git'
            fish -c 'fisher list | grep -q "franciscolourenco/done"' || fish -c 'fisher install franciscolourenco/done'
            ;;
        "zed")
            # Handle different zed command names
            if have_command zed; then
                echo "Zed already installed"
            elif have_command zed-editor; then
                echo "Found zed-editor, creating symlink to zed..."
                sudo ln -sf "$(which zed-editor)" /usr/local/bin/zed
            elif have_command zeditor; then
                echo "Found zeditor, creating symlink to zed..."
                sudo ln -sf "$(which zeditor)" /usr/local/bin/zed
            elif have_command zedit; then
                echo "Found zedit, creating symlink to zed..."
                sudo ln -sf "$(which zedit)" /usr/local/bin/zed
            else
                ensure_command zed
            fi
            ;;
    esac
}

# Install dependencies for all packages or specific one
if [[ $# -eq 0 ]]; then
    for deps_file in "$DEPS_DIR"/*; do
        [[ -f "$deps_file" ]] && install_deps "$(basename "$deps_file")"
    done
    
    # Handle custom installations
    install_custom "fish"
    install_custom "zed"
else
    install_deps "$1"
    install_custom "$1"
fi