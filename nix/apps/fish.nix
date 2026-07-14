# Mirrors install/fish.sh
{ config, pkgs, ... }:

let
  # Where this repo is checked out; the config link below points into it.
  dotfiles = "${config.home.homeDirectory}/.files";
in
{
  home.packages = with pkgs; [
    fish
    fzf
    zoxide
    lsd
  ];

  # Fish config, replacing its stow package (unstow before switching).
  # mkOutOfStoreSymlink links straight into the repo — same live-edit
  # behavior as stow (no rebuild needed to change a config), but the link
  # itself is declared here and applied atomically. Requires the repo at
  # ~/.files. Runtime files (fish_variables, fisher plugins) keep working
  # since the linked repo dir stays writable.
  xdg.configFile."fish".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fish/.config/fish";
}
