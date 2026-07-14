# Dotfiles Management

This repository uses GNU Stow to manage dotfiles across multiple applications and
shells, with per-application install/uninstall scripts that work on both Linux and
macOS.

## Quick Start

```bash
# Clone the repository with submodules (the nvim config is a submodule)
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
- **Shells**: Fish, Zsh (with Oh My Zsh + Powerlevel10k)
- **Editor**: Neovim (kickstart-based submodule), Zed
- **Tools**: Bat, Delta, Lazygit, Starship, Tmux
- **AI/CLI tooling**: Claude Code (settings, notification hook, skills), opencode, uv
- **Linux extras**: keyd (key remapper), run-or-raise (GNOME shortcuts)
- **macOS extras**: Finicky (browser router)
- **Themes**: Catppuccin themes for all supported applications

## Platform Support

The setup runs on **Linux** (apt / pacman / dnf) and **macOS** (Homebrew). GUI apps
are installed as Homebrew casks on macOS and via the system package manager on Linux.
On macOS, `setup.sh` bootstraps Homebrew automatically if it isn't installed yet.
Platform-specific packages are skipped automatically (neither installed nor stowed)
on platforms where they don't apply:

| Package        | Platform        | Notes                                         |
| -------------- | --------------- | --------------------------------------------- |
| `keyd`         | Linux only      | Kernel-level key remapper; stowed to `/`. Key remapping on macOS is handled outside these dotfiles. |
| `run-or-raise` | Linux only      | GNOME Mutter keybindings via `gsettings`      |
| `finicky`      | macOS only      | Browser router; installed via Homebrew cask   |

## How It Works

`scripts/setup.sh` discovers every application directory, then for each one:

1. Runs its dependency script `install/<app>.sh` (if present), which detects the
   package manager and installs the app plus any extras (plugins, themes, etc.).
2. Symlinks the config into place with `stow` (keyd is stowed to the system root `/`).

`scripts/utils.sh` provides the shared helpers (`ensure_command`, `ensure_cask`,
`install_packages`, `remove_package`, `unstow_config`, `confirm`).

### Supported Package Managers

- `apt` (Debian/Ubuntu)
- `pacman` (Arch Linux)
- `dnf` (Fedora)
- `brew` (macOS, formulae and casks)

## Nix (experimental)

`nix/` contains a [home-manager](https://nix-community.github.io/home-manager/)
flake as a declarative alternative to the `install/` scripts. It runs **standalone**
on Arch Linux and macOS — no NixOS involved. Nix only installs the CLI binaries
(same store paths on every machine and architecture, atomic rollbacks); the stow
packages keep managing all configs exactly as before. It currently declares a small
starter set (bat, delta, lazygit, starship, zoxide, fzf, lsd, ripgrep, fd, fish,
tmux) — add more to `home.packages` in `nix/home.nix` as needed.

Two apps' configs are also home-manager-managed (replacing their stow packages):

- **fish**: `home.nix` links `~/.config/fish` straight into this repo via
  `mkOutOfStoreSymlink`, so edits are live without a rebuild, just like stow.
- **tmux**: fully declarative via `programs.tmux` — home-manager generates
  `~/.config/tmux/tmux.conf` and installs the plugins (catppuccin theme,
  sensible, yank, resurrect, continuum) from nixpkgs. No TPM, no `prefix+I`;
  the theme works immediately. Trade-off: tmux config edits go in
  `nix/home.nix` and take effect on the next `home-manager switch`
  (`tmux/.tmux.conf` remains the source for stow-managed machines).

The other apps' configs stay stow-managed.

### From scratch

```bash
# 1. Install Nix (Determinate installer: works on Arch and macOS,
#    enables flakes out of the box, has a clean uninstaller)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Open a NEW terminal (the installer adds Nix to your shell), then apply:
cd ~/.files/nix
nix run home-manager -- switch --flake .#linux   # Arch / VM
nix run home-manager -- switch --flake .#mac     # macOS (Apple Silicon)

# 3. After the first switch, home-manager itself is installed:
home-manager switch --flake .#linux
```

Binaries land in `~/.nix-profile/bin`. The stowed fish config adds it to PATH
(`fish/.config/fish/conf.d/nix.fish`); other shells get it from the installer's
profile hook. Check with `which bat` — it should point into `/nix/store/...`.

Before switching on a machine that already has these tools from pacman/brew,
remove those copies (or accept that PATH order decides which one wins).

If your username or home directory differs (e.g. in a VM), adjust
`home.username` / `home.homeDirectory` in `nix/home.nix`.

### Updating an existing (stowed) machine to this setup

```bash
cd ~/.files && git pull                # get this branch's state
stow -D fish tmux                      # hand fish/tmux links over to home-manager
home-manager switch --flake ~/.files/nix#linux
exec fish                              # reload the shell; restart tmux sessions too
```

home-manager refuses to overwrite files it doesn't own, so unstowing first is
required — otherwise the switch fails on the existing `~/.config/fish` link
(alternatively `home-manager switch -b backup ...` moves conflicting files
aside automatically). After switching, restart tmux (`tmux kill-server`) so it
starts from the generated `~/.config/tmux/tmux.conf` with the nix-installed
plugins; a leftover `~/.tmux/plugins` dir from TPM can be deleted.

### Everyday commands

```bash
home-manager switch --flake ~/.files/nix#linux   # apply after editing home.nix
home-manager generations                          # list previous states
/nix/store/...-home-manager-generation/activate   # roll back: run any older generation's path
nix flake update ~/.files/nix                     # bump nixpkgs (then switch)
```

### Uninstalling Nix

```bash
/nix/nix-installer uninstall   # Determinate installer's clean removal
```

## Uninstalling

Each application has a matching teardown script in `uninstall/`:

```bash
# Remove a specific application (prompts for confirmation)
./uninstall/tmux.sh

# Remove everything
./uninstall_all.sh
```

## Manual Stow Usage

If you prefer to manage links manually:

```bash
# Stow a specific application
stow <app-name> --adopt

# Unstow an application
stow -D <app-name>
```

The `--adopt` flag is useful for first-time setup as it moves existing dotfiles into
this repository structure. Prefer stowing individual apps over the whole tree, so the
`install/`, `uninstall/`, and `scripts/` helper directories aren't linked into `$HOME`.

## Structure

```
.
├── alacritty/          # Alacritty terminal config
├── bat/                # Bat (cat alternative) config + themes
├── delta/              # Git delta pager config
├── finicky/            # Finicky browser router config (macOS)
├── fish/               # Fish shell config
├── ghostty/            # Ghostty terminal config
├── keyd/               # keyd key remapper config (Linux, stowed to /)
├── kitty/              # Kitty terminal config
├── lazygit/            # Lazygit TUI config
├── nvim/               # Neovim config (git submodule)
├── p10k/               # Powerlevel10k prompt config
├── run-or-raise/       # GNOME window-management shortcuts (Linux)
├── starship/           # Starship prompt config
├── tmux/               # Tmux terminal multiplexer config
├── zed/                # Zed editor config
├── zsh/                # Zsh shell config
├── nix/                # home-manager flake (experimental, see "Nix" above)
├── install/            # Per-app dependency install scripts
├── uninstall/          # Per-app uninstall scripts
├── uninstall_all.sh    # Runs every uninstall script
├── setup.sh            # Standalone OS-detecting bootstrap (alt. to scripts/)
└── scripts/
    ├── setup.sh        # Main installation/stow orchestrator
    └── utils.sh        # Package-manager + stow helpers
```

## Dependencies

The setup scripts automatically install:

- Core applications (the terminals, editors, and tools listed above)
- Shell tooling: `fzf`, `zoxide`, `vivid`, `lsd`, `trash-cli`, `starship`
- Node tooling for Fish: `fnm` (Node version manager), `bun`, and `@antfu/ni`
  (provides the `nr` command, installed via bun)
- Plugin/theme managers: `fisher` (Fish), Oh My Zsh + Powerlevel10k (Zsh),
  TPM (Tmux)
- Recommended: a Nerd Font for proper icon display

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
- **Permission errors**: Ensure scripts are executable: `chmod +x scripts/*.sh install/*.sh uninstall/*.sh`
- **Missing packages**: Run individual setup: `./scripts/setup.sh <app-name>`
- **keyd / run-or-raise skipped**: Expected on macOS / non-GNOME systems
```
