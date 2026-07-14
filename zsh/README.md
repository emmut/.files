# zsh (stow package)

On stow-managed machines this package provides `~/.zshrc` as usual.

On nix/home-manager machines, `nix/apps/zsh.nix` generates `~/.zshrc`
(via `programs.zsh`) with this file's content ported into it — run
`stow -D zsh` before `home-manager switch`, or the switch will conflict
(escape hatch: `home-manager switch -b backup`). The `p10k` stow package
(`~/.p10k.zsh`) stays stowed either way.
