# Runs install/zed.sh — GUI app, installed the preferred legacy way (brew
# cask / official installer, which sidesteps the vulkan-driver conflicts a
# packaged zed can hit, e.g. with mesa-git on CachyOS); see legacy.nix.
{ ... }:

{
  legacy.apps = [ "zed" ];
}
