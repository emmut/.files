#!/usr/bin/env bash

# Dotfiles setup script for macOS, Ubuntu, and Arch Linux
# Supports both Intel and Apple Silicon Macs

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Detect OS
detect_os() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
    log "Detected macOS"
  elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if command -v lsb_release >/dev/null 2>&1; then
      if lsb_release -d | grep -q "Ubuntu"; then
        OS="ubuntu"
        log "Detected Ubuntu"
      else
        # Check if it's Arch Linux
        if [[ -f /etc/arch-release ]]; then
          OS="arch"
          log "Detected Arch Linux"
        else
          error "Unsupported Linux distribution. Only Ubuntu and Arch Linux are supported."
        fi
      fi
    else
      # Check if it's Arch Linux (without lsb_release)
      if [[ -f /etc/arch-release ]]; then
        OS="arch"
        log "Detected Arch Linux"
      else
        error "Cannot determine Linux distribution. Only Ubuntu and Arch Linux are supported."
      fi
    fi
  else
    error "Unsupported operating system: $OSTYPE"
  fi
}

# Check if running on Apple Silicon
is_apple_silicon() {
  if [[ "$OS" == "macos" ]]; then
    if [[ $(uname -m) == "arm64" ]]; then
      return 0  # True - Apple Silicon
    fi
  fi
  return 1  # False - Intel or not macOS
}

# Install Homebrew on macOS
install_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    log "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if is_apple_silicon; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  else
    log "Homebrew already installed"
  fi
}

# Install packages on macOS
install_macos_packages() {
  log "Installing packages via Homebrew..."
  
  # Core packages needed for dotfiles
  brew install stow git ripgrep fd
  
  # Terminal and shell tools
  brew install zsh bat tmux
  
  # Text editors
  brew install neovim
  
  # Terminal emulators
  brew install kitty alacritty
  
  # Git tools
  brew install delta lazygit
  
  # Additional tools
  brew install fzf
  $(brew --prefix)/opt/fzf/install
  
  log "macOS package installation complete"
}

# Install packages on Ubuntu
install_ubuntu_packages() {
  log "Installing packages via apt..."
  
  # Update package list
  sudo apt update
  
  # Core packages needed for dotfiles
  sudo apt install -y stow git ripgrep fd-find
  
  # Terminal and shell tools
  sudo apt install -y zsh bat tmux
  
  # Text editors
  sudo apt install -y neovim
  
  # Terminal emulators
  sudo apt install -y kitty alacritty
  
  # Git tools
  sudo apt install -y delta lazygit
  
  # Additional tools
  sudo apt install -y fzf curl wget
  
  # Create symlinks for bat (batcat on Ubuntu)
  mkdir -p ~/.local/bin
  ln -sf /usr/bin/batcat ~/.local/bin/bat
  
  log "Ubuntu package installation complete"
}

# Install packages on Arch Linux
install_arch_packages() {
  log "Installing packages via pacman..."
  
  # Update package database
  sudo pacman -Syu --noconfirm
  
  # Core packages needed for dotfiles
  sudo pacman -S --noconfirm stow git ripgrep fd
  
  # Terminal and shell tools
  sudo pacman -S --noconfirm zsh bat tmux
  
  # Text editors
  sudo pacman -S --noconfirm neovim
  
  # Terminal emulators
  sudo pacman -S --noconfirm kitty alacritty
  
  # Git tools
  sudo pacman -S --noconfirm delta lazygit
  
  # Additional tools
  sudo pacman -S --noconfirm fzf curl wget
  
  log "Arch Linux package installation complete"
}

# Install Oh My Zsh
install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    log "Oh My Zsh already installed"
  fi
}

# Set zsh as default shell
set_zsh_default() {
  if [[ "$SHELL" != *"zsh"* ]]; then
    log "Setting zsh as default shell..."
    if [[ "$OS" == "macos" ]]; then
      sudo chsh -s /bin/zsh $(whoami)
    elif [[ "$OS" == "ubuntu" ]]; then
      sudo chsh -s /usr/bin/zsh $(whoami)
    elif [[ "$OS" == "arch" ]]; then
      sudo chsh -s /usr/bin/zsh $(whoami)
    fi
  else
    log "zsh is already the default shell"
  fi
}

# Run stow to link dotfiles
run_stow() {
  log "Linking dotfiles with stow..."
  
  # Change to dotfiles directory
  cd "$(dirname "$0")"
  
  # Stow all packages
  stow . --adopt
  
  log "Dotfiles linked successfully"
}

# Main setup function
main() {
  log "Starting dotfiles setup..."
  
  detect_os
  
  if [[ "$OS" == "macos" ]]; then
    install_homebrew
    install_macos_packages
  elif [[ "$OS" == "ubuntu" ]]; then
    install_ubuntu_packages
  elif [[ "$OS" == "arch" ]]; then
    install_arch_packages
  fi
  
  install_oh_my_zsh
  set_zsh_default
  run_stow
  
  log "Setup complete!"
  log "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
}

# Run main function if script is executed (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
