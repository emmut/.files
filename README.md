# Dotfiles Management

This repository uses GNU Stow to manage dotfiles across multiple applications and shells.

## Quick Start

```bash
# Clone the repository with submodules
git clone --recurse-submodules <repository-url>
cd dotfiles

# Install all applications and their dependencies
./scripts/setup.sh

# Or install a specific application only
./scripts/setup.sh tmux
./scripts/setup.sh zsh
```

## What's Included

- **Terminal Emulators**: Alacritty, Ghostty, Kitty
- **Shells**: Fish, Zsh (with Oh My Zsh)
- **Tools**: Bat, Delta, Lazygit, Starship, Tmux, Zed
- **Themes**: Catppuccin themes for all supported applications

## Installation Scripts

Each directory contains an `install.sh` script that:
- Detects your package manager (apt, pacman, dnf, brew)
- Installs required dependencies
- Sets up additional tools (plugins, themes, etc.)

### Supported Package Managers

- `apt` (Debian/Ubuntu)
- `pacman` (Arch Linux)
- `dnf` (Fedora)
- `brew` (macOS/Linux)

## Manual Stow Usage

If you prefer to manage installations manually:

```bash
# Stow a specific application
stow <app-name> --adopt

# Stow all applications
stow . --adopt

# Unstow an application
stow -D <app-name>
```

The `--adopt` flag is useful for first-time setup as it moves existing dotfiles into this repository structure.

## Structure

```
.
├── alacritty/          # Alacritty terminal config
├── bat/                # Bat (cat alternative) config
├── delta/              # Git delta pager config
├── fish/               # Fish shell config
├── ghostty/            # Ghostty terminal config
├── kitty/               # Kitty terminal config
├── lazygit/            # Lazygit TUI config
├── scripts/             # Setup and utility scripts
│   ├── setup.sh         # Main installation script
│   └── utils.sh         # Package manager utilities
├── starship/            # Starship prompt config
├── tmux/               # Tmux terminal multiplexer config
├── zed/                # Zed editor config
└── zsh/                # Zsh shell config
```

## Dependencies

The setup script automatically installs:
- Core applications (alacritty, ghostty, kitty, etc.)
- Shell tools (fzf, zoxide, vivid)
- Plugin managers (TPM for tmux, Oh My Zsh)
- Required fonts (Nerd Fonts recommended)

## Post-Installation

1. **Set your default shell** (if using zsh or fish):
   ```bash
   chsh -s $(which zsh)  # or fish
   ```

2. **Install Nerd Fonts** for proper icon display:
   - macOS: `brew install --cask font-fira-code-nerd-font`
   - Linux: Install via your distribution's package manager

3. **Configure Git** to use delta:
   ```bash
   git config --global core.pager "delta --syntax-theme='Catppuccin Mocha' --paging=never"
   ```

## Troubleshooting

- **Stow conflicts**: Use `--adopt` flag on first run
- **Permission errors**: Ensure scripts are executable: `chmod +x scripts/*.sh */install.sh`
- **Missing packages**: Run individual setup: `./scripts/setup.sh <app-name>`