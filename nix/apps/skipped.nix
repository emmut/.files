# Install scripts intentionally NOT mapped to nix — their legacy scripts
# (`./scripts/setup.sh <app>`) remain authoritative. This module is a no-op;
# it exists so every install/*.sh has an accounted-for counterpart here.
#
#   keyd.sh
#     keyd is a system-level daemon: it needs a root systemd service
#     (`systemctl enable --now keyd`) and uinput access, and its config
#     lives in /etc/keyd. Standalone home-manager only manages the user
#     environment, so this genuinely cannot be done here — the services.keyd
#     module exists only on NixOS. Run `./scripts/setup.sh keyd` as before.
{ ... }:

{ }
