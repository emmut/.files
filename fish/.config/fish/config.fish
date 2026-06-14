if test -f /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# Format man pages
set -x MANROFFOPT "-c"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    # fnm environment setup
    if test -d ~/.fnm
        set -gx PATH "$HOME/.fnm:$PATH"
        if command -v fnm >/dev/null 2>&1
            fnm env --use-on-cd --shell fish --corepack-enabled --version-file-strategy recursive | source
            fnm completions --shell fish | source
        end
    end
    starship init fish | source
    zoxide init fish | source

    # LS_COLORS setup
    if command -v vivid >/dev/null 2>&1
        set -gx LS_COLORS (vivid generate catppuccin-macchiato)
    end
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
