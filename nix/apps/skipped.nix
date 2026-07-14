# Install scripts intentionally NOT mapped to nix — their legacy scripts
# (`./scripts/setup.sh <app>`) remain authoritative. This module is a no-op;
# it exists so every install/*.sh has an accounted-for counterpart here.
#
#   alacritty.sh, kitty.sh, ghostty.sh, zed.sh, finicky.sh
#     GUI apps. On non-NixOS Arch, nix-built GUI apps risk OpenGL/driver
#     mismatches; on macOS there's no clean /Applications integration.
#     If ever revisited: ghostty is `ghostty` (linux) / `ghostty-bin`
#     (darwin) in nixpkgs; finicky isn't packaged at all.
#
#   keyd.sh
#     Needs a root systemd service plus uinput access; home-manager has no
#     services.keyd (that's a NixOS module).
#
#   run-or-raise.sh
#     GNOME extension + gsettings. `gnomeExtensions.run-or-raise` exists,
#     but shell-version drift on Arch makes extensions.gnome.org safer.
{ ... }:

{ }
