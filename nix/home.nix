{ pkgs, ... }:

{
  home.username = "emmut";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/emmut" else "/home/emmut";

  # Never change this after the first switch; it pins compatibility behavior.
  home.stateVersion = "25.05";

  # Let home-manager manage itself so `home-manager` stays on PATH.
  programs.home-manager.enable = true;

  # Non-NixOS integration: puts the nix profile on XDG_DATA_DIRS (via
  # ~/.config/environment.d and shell session vars) so desktop entries and
  # fish vendor plugins installed by nix are found.
  targets.genericLinux.enable = pkgs.stdenv.isLinux;

  # One module per install script: nix/apps/<app>.nix mirrors
  # install/<app>.sh. The legacy scripts remain authoritative for
  # stow-managed machines; binaries here come from the Nix store with
  # identical paths on Arch and macOS.
  # To uninstall an app the nix way: remove its line here and run
  # `home-manager switch`. For nixpkgs-backed apps the package (and any
  # generated config) is removed atomically; for legacy-bridged apps (GUI
  # tools, keyd — see apps/legacy.nix) the matching uninstall/<app>.sh runs.
  imports = [
    ./apps/alacritty.nix
    ./apps/bat.nix
    ./apps/claude.nix
    ./apps/delta.nix
    ./apps/finicky.nix
    ./apps/fish.nix
    ./apps/ghostty.nix
    ./apps/keyd.nix
    ./apps/kitty.nix
    ./apps/lazygit.nix
    ./apps/legacy.nix
    ./apps/nvim.nix
    ./apps/run-or-raise.nix
    ./apps/starship.nix
    ./apps/tmux.nix
    ./apps/worktrunk.nix
    ./apps/zed.nix
    ./apps/zsh.nix
  ];
}
