# Mirrors install/bat.sh
{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.bat ];

  # The bat config uses a Catppuccin theme; the theme files come from the
  # stowed bat package. Rebuild the theme cache so bat (and delta) can find
  # them — guarded by a grep so it's a no-op once built.
  home.activation.batCache = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ! ${pkgs.bat}/bin/bat --list-themes 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "Catppuccin"; then
      run ${pkgs.bat}/bin/bat cache --build
    fi
  '';
}
