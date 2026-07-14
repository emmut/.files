# Mirrors install/kitty.sh (config stays in the stowed kitty package)
{ config, pkgs, ... }:

{
  home.packages = [ (config.lib.nixGL.wrap pkgs.kitty) ];
}
