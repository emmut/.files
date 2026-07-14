# Mirrors the cursor section of install/fish.sh (the `c` fish alias);
# there is no standalone install/cursor.sh.
{ config, pkgs, ... }:

{
  # code-cursor is unfree — allowed via the predicate in flake.nix.
  # Like claude-code, the nix package can't self-update and may trail the
  # upstream release.
  home.packages = [ (config.lib.nixGL.wrap pkgs.code-cursor) ];
}
