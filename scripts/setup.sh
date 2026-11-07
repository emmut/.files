#!/bin/bash
#
# This script symlinks the dotfiles to the home directory using stow.
# It also attempts to install stow if it is not found, and runs
# dependency installation scripts (install.sh) in each stow directory.

set -e

# Run from the repo root so `find`, install/ paths, and git status work
# regardless of where the script was invoked from.
cd "$(dirname "$0")/.."

# Source the utility script
source "scripts/utils.sh"

# Function to install stow if not found
install_stow() {
    echo "stow is not installed. Attempting to install..."
    install_packages stow
}

# On macOS everything installs through Homebrew, so bootstrap it first.
if [ "$(uname -s)" = "Darwin" ]; then
    # A fresh terminal may not have brew on PATH even when it's installed
    # (Apple Silicon: /opt/homebrew, Intel: /usr/local).
    if ! command -v brew >/dev/null 2>&1; then
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            if [ -x "$brew_bin" ]; then
                eval "$("$brew_bin" shellenv)"
                break
            fi
        done
    fi
    if ! command -v brew >/dev/null 2>&1; then
        echo "Homebrew not found. Installing it first..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew; do
            if [ -x "$brew_bin" ]; then
                eval "$("$brew_bin" shellenv)"
                break
            fi
        done
        if ! command -v brew >/dev/null 2>&1; then
            echo "Error: Homebrew installation failed. Install it manually from https://brew.sh and re-run."
            exit 1
        fi
    fi
fi

# Package dependencies: selecting a package also processes the ones it
# requires. lazygit's config uses delta as its pager with a theme from
# bat's cache, so both must be installed and stowed alongside it.
package_deps() {
    case "$1" in
        lazygit) echo "delta bat" ;;
    esac
}

# Expand a package list with dependencies (deps first), deduplicated.
expand_deps() {
    local out="" d dep
    for d in $1; do
        for dep in $(package_deps "$d") "$d"; do
            case " $out " in
                *" $dep "*) ;;
                *) out="$out $dep" ;;
            esac
        done
    done
    echo "$out"
}

# Ask for the sudo password once up front so package installs don't stall
# mid-run waiting for it.
prime_sudo

# Packages that only apply to one platform: skip both their install script
# and stowing anywhere else. keyd's key remapping is handled by a non-CLI
# solution on macOS, so it stays Linux-only.
skip_package() {
    local dir="$1" os
    os="$(uname -s)"
    case "$dir" in
        keyd|run-or-raise)
            [ "$os" != "Linux" ] && return 0 ;;
        finicky)
            [ "$os" != "Darwin" ] && return 0 ;;
    esac
    return 1
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

# Pull in dependencies of the selected packages.
STOW_DIRS=$(expand_deps "$STOW_DIRS")

# Track packages whose setup did not fully succeed.
FAILED=""

# Process each directory
for dir in $STOW_DIRS; do
    echo "Processing $dir..."

    # Skip platform-specific packages on other platforms.
    if skip_package "$dir"; then
        echo "Skipping $dir (not for this platform)..."
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
    STATUS_BEFORE=$(git status --porcelain -- "$dir")
    if [ "$dir" = "keyd" ]; then
        echo "Using system target / for keyd package..."
        if ! sudo stow -v -R --adopt --target=/ "$dir"; then
            echo "WARNING: stow failed for $dir."
            FAILED="$FAILED $dir"
        else
            restore_adopted "$STATUS_BEFORE" "$dir"
            # keyd was started by install/keyd.sh before the config existed;
            # reload so the freshly linked /etc/keyd/default.conf takes effect.
            sudo keyd reload || sudo systemctl restart keyd || true
        fi
    else
        if ! stow -v -R --adopt --target="$HOME" "$dir"; then
            echo "WARNING: stow failed for $dir."
            FAILED="$FAILED $dir"
        else
            restore_adopted "$STATUS_BEFORE" "$dir"
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
