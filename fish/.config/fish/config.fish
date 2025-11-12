brew shellenv | source

if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    zoxide init fish | source
    fnm env --use-on-cd --shell fish --corepack-enabled --version-file-strategy recursive | source
end
