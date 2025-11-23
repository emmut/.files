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

