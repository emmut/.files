{ pkgs, ... }:

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
  ];
}
