# Runs install/run-or-raise.sh — GNOME extension + gsettings keybindings,
# installed from extensions.gnome.org (matching the running shell version)
# by the legacy script, orchestrated by nix; see legacy.nix. The script
# itself is a no-op without GNOME/gsettings.
{ ... }:

{
  legacy.apps = [ "run-or-raise" ];
}
