# Mirrors install/worktrunk.sh (which also installs sesh; gum comes along
# for the tmux sesh popup, matching install/tmux.sh's best-effort installs).
{ pkgs, ... }:

{
  # Shell integration is handled by the stowed fish function/completions,
  # same as the legacy script (no `wt config shell install`).
  home.packages = with pkgs; [
    worktrunk
    sesh
    gum
  ];
}
