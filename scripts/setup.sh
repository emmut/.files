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
    # Exclude .git, helper script dirs, and other non-dotfile directories
    STOW_DIRS=$(find . -maxdepth 1 -type d -not -name ".*" -not -name "scripts" -not -name "install" -not -name "uninstall" -not -name "README.md" -exec basename {} \; | sort)

    # When running interactively with no specific app, offer a checkbox menu.
    if [ -t 0 ] && [ -t 1 ]; then
        # gum renders the checkbox UI; install it on first run (best-effort).
        if ! command -v gum >/dev/null 2>&1; then
            echo "Installing gum for the interactive selector..."
            ensure_command gum || true
        fi

        if command -v gum >/dev/null 2>&1; then
            ALL_LABEL="[ Select all ]"
            SELECTED=$(printf '%s\n' "$ALL_LABEL" $STOW_DIRS | gum choose --no-limit \
                --height=20 \
                --header="Choose apps (space toggles, enter confirms). Pick '[ Select all ]' for everything:")
            if [ -z "$SELECTED" ]; then
                echo "Nothing selected. Exiting."
                exit 0
            fi
            # "[ Select all ]" expands to the full discovered list; otherwise use the picks.
            if ! printf '%s\n' "$SELECTED" | grep -qxF "$ALL_LABEL"; then
                STOW_DIRS=$SELECTED
            fi
        else
            echo "gum unavailable; continuing with all applications."
        fi
    fi
fi

# Track packages whose setup did not fully succeed.
FAILED=""

# Process each directory
for dir in $STOW_DIRS; do
    echo "Processing $dir..."

    # Skip Linux-only packages on other platforms (e.g. keyd on macOS).
    if [ "$dir" = "keyd" ] && [ "$(uname -s)" != "Linux" ]; then
        echo "Skipping keyd (Linux only)..."
        continue
    fi

    # Run the dependency script (non-fatal: one failure must not abort the whole run).
    if [ -f "install/$dir.sh" ]; then
        echo "Found dependency script for $dir. Running it..."
        chmod +x "install/$dir.sh"
        if ! ./install/"$dir.sh"; then
            echo "WARNING: install/$dir.sh failed; skipping $dir."
            FAILED="$FAILED $dir"
            continue
        fi
    fi

    echo "Stowing $dir..."
    if [ "$dir" = "keyd" ]; then
        echo "Using system target / for keyd package..."
        if ! sudo stow -v -R --adopt --target=/ "$dir"; then
            echo "WARNING: stow failed for $dir."
            FAILED="$FAILED $dir"
        fi
    else
        if ! stow -v -R --adopt "$dir"; then
            echo "WARNING: stow failed for $dir."
            FAILED="$FAILED $dir"
        fi
    fi
done

if [ -n "$FAILED" ]; then
    echo
    echo "Done, but these packages had problems:$FAILED"
    echo "Re-run ./scripts/setup.sh <app> after resolving them."
else
    echo "Done."
fi
