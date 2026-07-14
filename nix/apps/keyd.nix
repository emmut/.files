# Runs install/keyd.sh — keyd needs a root systemd service and /etc config,
# which standalone home-manager can't manage, so the legacy script does the
# real work (via sudo) and nix orchestrates it; see legacy.nix. The script
# itself is a no-op on macOS.
{ ... }:

{
  legacy.apps = [ "keyd" ];
}
