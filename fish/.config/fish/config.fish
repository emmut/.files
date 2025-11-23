if test -f /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
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
end
