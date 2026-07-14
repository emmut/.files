# Mirrors install/starship.sh
{ pkgs, ... }:

{
  # Package only — the config stays in the stowed starship package.
  # Deliberately NOT programs.starship: it would generate starship.toml
  # and clash with the stow-managed one.
  home.packages = [ pkgs.starship ];
}
