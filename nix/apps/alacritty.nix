# Mirrors install/alacritty.sh (config stays in the stowed alacritty package)
{ config, pkgs, ... }:

{
  home.packages = [
    (config.lib.nixGL.wrap pkgs.alacritty)
    # The legacy script only warns when a Nerd Font is missing; here the
    # font is simply declared.
    pkgs.nerd-fonts.fira-code
  ];

  # Make fontconfig discover fonts installed into the nix profile on
  # non-NixOS systems.
  fonts.fontconfig.enable = true;
}
