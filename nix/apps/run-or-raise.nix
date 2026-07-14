# Mirrors install/run-or-raise.sh (Linux/GNOME only; the shortcuts.conf
# stays in the stowed run-or-raise package).
#
# The extension comes from nixpkgs instead of extensions.gnome.org — if its
# supported shell version drifts behind Arch's GNOME, the legacy script is
# the fallback. GNOME Shell finds nix-profile extensions via XDG_DATA_DIRS
# (targets.genericLinux + environment.d in home.nix); log out and back in
# after the first switch so the session picks that up.
{ lib, pkgs, ... }:

lib.mkIf pkgs.stdenv.isLinux {
  home.packages = with pkgs; [
    gnomeExtensions.run-or-raise
    wl-clipboard
    # AUR-only in the legacy script; nixpkgs has it directly.
    wofi-emoji
  ];

  # Replaces the imperative `gsettings set` calls. NOTE: dconf keys are
  # owned wholesale — enabled-extensions REPLACES the list, so extensions
  # enabled by hand get disabled on switch; add them here instead.
  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [ "run-or-raise@edvard.cz" ];
    };

    # Map GNOME window management shortcuts to Hyper (Caps -> C-A-S in keyd).
    "org/gnome/mutter/keybindings" = {
      toggle-tiled-left = [ "<Control><Alt><Shift>Left" ];
      toggle-tiled-right = [ "<Control><Alt><Shift>Right" ];
    };
    "org/gnome/desktop/wm/keybindings" = {
      toggle-maximized = [
        "<Control><Alt><Shift>Return"
        "<Control><Alt><Shift>KP_Enter"
      ];
      # Move focused window between workspaces without Super.
      move-to-workspace-left = [ "<Control><Alt><Shift>j" ];
      move-to-workspace-right = [ "<Control><Alt><Shift>k" ];
      # Switch workspaces without moving the focused window.
      switch-to-workspace-left = [ "<Control><Alt><Shift>u" ];
      switch-to-workspace-right = [ "<Control><Alt><Shift>i" ];
      minimize = [ "<Super>h" ];
    };
  };
}
