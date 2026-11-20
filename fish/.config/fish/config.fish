# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/emiljansson/.docker/bin"
# End of Docker Desktop section.

/opt/homebrew/bin/brew shellenv | source
fish_add_path --move --path ~/.local/share/mise/shims

if status is-interactive
    # Commands to run in interactive sessions can go here
    mise activate fish | source
    starship init fish | source
    zoxide init fish | source
end

set -g desktop ~/Desktop
set -g downloads ~/Downloads

# Editors
set -Ux EDITOR nvim
set -Ux VISUAL nvim

# XDG base directory
set --export XDG_CONFIG_HOME "$HOME/.config"

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/emiljansson/.cache/lm-studio/bin
# End of LM Studio CLI section



# next dev / Turbopack exceed the macOS default of 256 open files (EMFILE)
ulimit -n 65536
