{ pkgs, ... }:

{
  home.username = "emmut";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/emmut" else "/home/emmut";

  # Never change this after the first switch; it pins compatibility behavior.
  home.stateVersion = "25.05";

  # Let home-manager manage itself so `home-manager` stays on PATH.
  programs.home-manager.enable = true;

  # One module per install script: nix/apps/<app>.nix mirrors
  # install/<app>.sh. The legacy scripts remain authoritative for
  # stow-managed machines; binaries here come from the Nix store with
  # identical paths on Arch and macOS.
  imports = [
    ./apps/bat.nix
    ./apps/delta.nix
    ./apps/fish.nix
    ./apps/lazygit.nix
    ./apps/nvim.nix
    ./apps/starship.nix
    ./apps/tmux.nix
  ];
}
