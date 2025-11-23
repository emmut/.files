#!/bin/bash
#
# This script symlinks the dotfiles to the home directory using stow.
# It also attempts to install stow if it is not found, and runs
# dependency installation scripts (install.sh) in each stow directory.

set -e

# Source the utility script
source "$(dirname "$0")/utils.sh"

# Function to install stow if not found
install_stow() {
    echo "stow is not installed. Attempting to install..."
    install_packages stow
}


# Check if stow is installed
if ! command -v stow &> /dev/null; then
    install_stow
fi

# If an argument is provided, use it as the only stow directory
if [ -n "$1" ]; then
    if [ ! -d "$1" ]; then
        echo "Error: Directory '$1' not found."
        exit 1
    fi
    STOW_DIRS=$1
else
    # Find all directories that can be stowed
    # Exclude .git, scripts, and other non-dotfile directories
    STOW_DIRS=$(find . -maxdepth 1 -type d -not -name ".*" -not -name "scripts" -not -name "README.md" -exec basename {} \;)
fi

# Process each directory
for dir in $STOW_DIRS; do
    echo "Processing $dir..."

    # Check for and run dependency script
    if [ -f "$dir/install.sh" ]; then
        echo "Found dependency script in $dir. Running it..."
        chmod +x "$dir/install.sh"
        (cd "$dir" && ./install.sh)
    fi

    echo "Stowing $dir..."
    stow -v -R --adopt -t "$HOME" "$dir"
done

echo "Done."

