# Runs install/kitty.sh — GUI app, installed the preferred legacy way
# (brew cask / pacman) but orchestrated by nix; see legacy.nix.
{ ... }:

{
  legacy.apps = [ "kitty" ];
}
