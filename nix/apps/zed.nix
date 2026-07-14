# Mirrors install/zed.sh (config stays in the stowed zed package)
#
# Zed renders via Vulkan; the nixGL wrap (with nixGL.vulkan.enable) points
# it at the host's ICDs, which is the same driver-mismatch problem the
# legacy script's official-installer route was avoiding. If it still
# misbehaves (e.g. mesa-git on CachyOS), install/zed.sh remains the
# fallback.
{ config, pkgs, ... }:

let
  zed = config.lib.nixGL.wrap pkgs.zed-editor;
in
{
  home.packages = [
    zed
    # nixpkgs names the binary `zeditor`; keep the `zed` command the stowed
    # fish config and muscle memory expect.
    (pkgs.writeShellScriptBin "zed" ''exec ${zed}/bin/zeditor "$@"'')
  ];
}
