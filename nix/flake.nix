{
  description = "Dotfiles packages via home-manager (standalone: Arch Linux + macOS, no NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      mkHome = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./home.nix ];
        };
    in {
      homeConfigurations = {
        # Pick the one matching the machine:
        #   home-manager switch --flake .#linux   (Arch / the VM, x86_64)
        #   home-manager switch --flake .#mac     (Apple Silicon)
        "linux" = mkHome "x86_64-linux";
        "mac" = mkHome "aarch64-darwin";
      };
    };
}
