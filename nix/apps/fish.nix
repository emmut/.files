# Mirrors install/fish.sh
#
# Deliberate deviations from the script:
#   - nodejs from nixpkgs replaces fnm + `fnm install --lts` (no fnm).
#   - ni comes from nixpkgs instead of `bun add -g @antfu/ni`.
#   - opencode from nixpkgs lags upstream by days–weeks; the legacy script
#     stays the bleeding-edge option.
#   - cursor is a GUI app -> skipped (see skipped.nix).
#   - curl/git are assumed present (nix itself needs them).
{ config, pkgs, ... }:

let
  # Where this repo is checked out; the config link below points into it.
  dotfiles = "${config.home.homeDirectory}/.files";
in
{
  home.packages = with pkgs; [
    fish
    fzf
    vivid
    zoxide
    trash-cli
    lsd
    # killport uses lsof to find processes by port
    lsof
    unzip
    nodejs
    bun
    ni
    uv
    opencode
    # the install script drops cht.sh into ~/.local/bin as `cheat`
    (writeShellScriptBin "cheat" ''exec ${cht-sh}/bin/cht.sh "$@"'')

    # Plugins declaratively instead of fisher: their vendor_conf.d /
    # vendor_functions.d land under ~/.nix-profile/share/fish/, which fish
    # auto-loads via XDG_DATA_DIRS (home-manager sets the session vars).
    # programs.fish is deliberately unused — it would generate config.fish
    # and clash with the live-edit symlink below. Fallback if the vendor
    # dirs don't load: fisher still works (fish_plugins is in the linked
    # config dir).
    fishPlugins.plugin-git
    fishPlugins.done
  ];

  # Fish config, replacing its stow package (unstow before switching).
  # mkOutOfStoreSymlink links straight into the repo — same live-edit
  # behavior as stow (no rebuild needed to change a config), but the link
  # itself is declared here and applied atomically. Requires the repo at
  # ~/.files. Runtime files (fish_variables, fisher plugins) keep working
  # since the linked repo dir stays writable.
  xdg.configFile."fish".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/fish/.config/fish";
}
