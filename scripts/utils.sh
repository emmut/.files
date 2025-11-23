#!/bin/bash

# Function to install packages using the detected package manager
install_packages() {
    echo "Ensuring packages are installed: $@"
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y "$@"
    elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm --needed "$@"
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y "$@"
    elif command -v brew &> /dev/null; then
        brew install "$@"
    else
        echo "Could not determine package manager. Please install packages manually: $@"
        return 1
    fi
}

have_command() {
    command -v "$1" >/dev/null 2>&1
}

ensure_command() {
    local cmd="$1"
    local pkg="${2:-$cmd}"

    if have_command "$cmd"; then
        echo "$cmd already installed."
        return 0
    fi

    install_packages "$pkg"
}

# Function to remove packages using the detected package manager
remove_package() {
    local pkg="$1"
    echo "Removing package: $pkg"
    
    if command -v brew &> /dev/null; then
        brew uninstall "$pkg" 2>/dev/null || echo "$pkg not found in brew"
    elif command -v apt-get &> /dev/null; then
        sudo apt-get remove -y "$pkg" 2>/dev/null || echo "$pkg not found in apt"
    elif command -v pacman &> /dev/null; then
        sudo pacman -R --noconfirm "$pkg" 2>/dev/null || echo "$pkg not found in pacman"
    elif command -v dnf &> /dev/null; then
        sudo dnf remove -y "$pkg" 2>/dev/null || echo "$pkg not found in dnf"
    else
        echo "Could not determine package manager. Please remove package manually: $pkg"
        return 1
    fi
}

# Function to unstow configuration using GNU Stow
unstow_config() {
    local config_name="$1"
    local dotfiles_dir="$(dirname "$(dirname "$0")")"
    
    if command -v stow >/dev/null 2>&1; then
        echo "Unstowing $config_name configuration..."
        cd "$dotfiles_dir"
        stow -d . -D "$config_name" 2>/dev/null || echo "$config_name not stowed or already unstowed"
    else
        echo "Warning: stow not found, removing config directory directly"
        rm -rf "$HOME/.config/$config_name"
    fi
}

# Function to get user confirmation
confirm() {
    local package_name="$1"
    local default="${2:-n}"
    
    if [[ "$default" == "y" ]]; then
        read -p "Are you sure you want to uninstall $package_name? [Y/n]: " response
        case "$response" in
            [nN][oO]|[nN]) return 1 ;;
            *) return 0 ;;
        esac
    else
        read -p "Are you sure you want to uninstall $package_name? [y/N]: " response
        case "$response" in
            [yY][eE][sS]|[yY]) return 0 ;;
            *) return 1 ;;
        esac
    fi
}

