# Mirrors install/nvim.sh
{ lib, pkgs, ... }:

{
  # The nvim config (emmut/kickstart.nvim) stays the stowed git submodule;
  # initializing it is still install/nvim.sh's job (or
  # `git submodule update --init nvim/.config/nvim`).
  home.packages = with pkgs; [
    neovim
    # kickstart.nvim dependencies: telescope uses ripgrep and fd, and
    # treesitter/mason need make, gcc, and unzip to build parsers and tools.
    ripgrep
    fd
    gnumake
    unzip
  ]
  # gcc only on Linux: on macOS the nix gcc would shadow Apple clang.
  ++ lib.optionals pkgs.stdenv.isLinux [ gcc ];
}
