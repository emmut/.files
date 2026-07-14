# Mirrors install/delta.sh
{ pkgs, ... }:

{
  # nixpkgs attribute is `delta` (not `git-delta` as on some distros).
  home.packages = [ pkgs.delta ];
}
