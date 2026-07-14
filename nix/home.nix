{ config, pkgs, ... }:

let
  # Where this repo is checked out; the config links below point into it.
  dotfiles = "${config.home.homeDirectory}/.files";
in
{
  home.username = "emmut";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/emmut" else "/home/emmut";

  # Never change this after the first switch; it pins compatibility behavior.
  home.stateVersion = "25.05";

  # Let home-manager manage itself so `home-manager` stays on PATH.
  programs.home-manager.enable = true;

  # Starter set to try in the VM. Binaries come from the Nix store with
  # identical paths on Arch and macOS (no more brew-prefix differences);
  # the stow packages in this repo keep managing all the configs.
  home.packages = with pkgs; [
    bat
    delta
    lazygit
    starship
    zoxide
    fzf
    lsd
    ripgrep
    fd
    fish
    tmux
  ];

  # Configs for fish and tmux, replacing their stow packages (unstow them
  # before switching). mkOutOfStoreSymlink links straight into the repo —
  # same live-edit behavior as stow (no rebuild needed to change a config),
  # but the links themselves are declared here and applied atomically.
  # Requires the repo at ~/.files. Runtime files (fish_variables, fisher
  # plugins) keep working since the linked repo dir stays writable.
  xdg.configFile."fish".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fish/.config/fish";
  home.file.".tmux.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/.tmux.conf";
}
