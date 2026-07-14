{ pkgs, nixglPackages, ... }:

{
  home.username = "emmut";
  home.homeDirectory =
    if pkgs.stdenv.isDarwin then "/Users/emmut" else "/home/emmut";

  # Never change this after the first switch; it pins compatibility behavior.
  home.stateVersion = "25.05";

  # Let home-manager manage itself so `home-manager` stays on PATH.
  programs.home-manager.enable = true;

  # GUI apps are wrapped with nixGL (config.lib.nixGL.wrap) so they find the
  # host's OpenGL/Vulkan drivers on non-NixOS Linux. On macOS nixglPackages
  # is null, which turns every wrap into a no-op.
  nixGL.packages = nixglPackages;
  nixGL.defaultWrapper = "mesa";
  nixGL.vulkan.enable = pkgs.stdenv.isLinux;

  # Non-NixOS integration: puts the nix profile on XDG_DATA_DIRS (via
  # ~/.config/environment.d and shell session vars) so desktop entries,
  # fish vendor plugins, and GNOME extensions installed by nix are found.
  targets.genericLinux.enable = pkgs.stdenv.isLinux;

  # One module per install script: nix/apps/<app>.nix mirrors
  # install/<app>.sh. The legacy scripts remain authoritative for
  # stow-managed machines; binaries here come from the Nix store with
  # identical paths on Arch and macOS.
  # To uninstall an app the nix way: remove its line here and run
  # `home-manager switch` — the package (and any generated config) is
  # removed atomically; `home-manager generations` can roll it back.
  imports = [
    ./apps/alacritty.nix
    ./apps/bat.nix
    ./apps/claude.nix
    ./apps/cursor.nix
    ./apps/delta.nix
    ./apps/finicky.nix
    ./apps/fish.nix
    ./apps/ghostty.nix
    ./apps/kitty.nix
    ./apps/lazygit.nix
    ./apps/nvim.nix
    ./apps/run-or-raise.nix
    ./apps/skipped.nix
    ./apps/starship.nix
    ./apps/tmux.nix
    ./apps/worktrunk.nix
    ./apps/zed.nix
    ./apps/zsh.nix
  ];
}
