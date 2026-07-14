# Mirrors install/ghostty.sh (config stays in the stowed ghostty package)
{ config, pkgs, ... }:

{
  home.packages = [
    # Source build on Linux (nixGL-wrapped for the host GL drivers);
    # upstream binary .app on macOS, linked into
    # ~/Applications/Home Manager Apps.
    (if pkgs.stdenv.isDarwin
     then pkgs.ghostty-bin
     else config.lib.nixGL.wrap pkgs.ghostty)
  ];
}
