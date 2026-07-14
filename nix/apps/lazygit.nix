# Mirrors install/lazygit.sh
{ pkgs, ... }:

{
  # The lazygit config uses delta as its pager with bat's Catppuccin theme
  # cache. On stow machines that dependency is wired up via package_deps in
  # scripts/setup.sh; here home.nix simply imports bat.nix and delta.nix
  # alongside this module, so no dependency mechanism is needed.
  home.packages = [ pkgs.lazygit ];
}
