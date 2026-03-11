/opt/homebrew/bin/brew shellenv | source

if status is-interactive
    # Commands to run in interactive sessions can go here
    fnm env --use-on-cd --shell fish --corepack-enabled --version-file-strategy recursive | source
    starship init fish | source
    zoxide init fish | source
end

set -g desktop ~/Desktop
set -g downloads ~/Downloads

# XDG base directory
set --export XDG_CONFIG_HOME "$HOME/.config"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
