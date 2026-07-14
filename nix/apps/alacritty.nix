# Runs install/alacritty.sh — GUI app, installed the preferred legacy way
# (brew cask / pacman) but orchestrated by nix; see legacy.nix.
{ ... }:

{
  legacy.apps = [ "alacritty" ];
}
