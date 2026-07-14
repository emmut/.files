# Mirrors install/nvim.sh
{ pkgs, ... }:

{
  # The nvim config (emmut/kickstart.nvim) stays the stowed git submodule;
  # initializing it is still install/nvim.sh's job (or
  # `git submodule update --init nvim/.config/nvim`).
  home.packages = with pkgs; [
    ripgrep
    fd
  ];
}
