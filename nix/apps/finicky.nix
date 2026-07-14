# Runs install/finicky.sh — macOS-only browser router, installed the
# preferred legacy way (brew cask) but orchestrated by nix; see legacy.nix.
# The script itself is a no-op on Linux.
{ ... }:

{
  legacy.apps = [ "finicky" ];
}
