# Mirrors install/claude.sh
{ lib, pkgs, ... }:

{
  # claude-code is unfree — allowed via the predicate in flake.nix.
  # Unlike the official installer, the nix-packaged CLI can't self-update
  # and may trail the npm release by a bit.
  home.packages = [ pkgs.claude-code ]
    # notify.sh uses notify-send on Linux; macOS uses osascript (built in).
    ++ lib.optionals pkgs.stdenv.isLinux [ pkgs.libnotify ];
}
