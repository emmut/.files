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
    starship init fish | source
    zoxide init fish | source

    # fnm environment setup
    if test -d ~/.fnm
        set -gx PATH "$HOME/.fnm:$PATH"
        if command -v fnm >/dev/null 2>&1
            fnm env --use-on-cd --shell fish --corepack-enabled --version-file-strategy recursive | source
        end
    end

    # LS_COLORS setup
    if command -v vivid >/dev/null 2>&1
        set -gx LS_COLORS (vivid generate catppuccin-macchiato)
    end
end
