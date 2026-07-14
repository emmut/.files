{
  description = "Dotfiles packages via home-manager (standalone: Arch Linux + macOS, no NixOS)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # OpenGL/Vulkan shims so nix-built GUI apps (alacritty, kitty, ghostty,
    # zed, cursor) find the host drivers on non-NixOS Linux.
    nixgl = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }:
    let
      mkHome = system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            # Unfree packages, allowed explicitly (and nothing else).
            config.allowUnfreePredicate = pkg:
              builtins.elem (nixpkgs.lib.getName pkg) [
                "claude-code"
                "cursor"
                "code-cursor"
              ];
          };
          extraSpecialArgs = {
            # null on darwin: the nixGL wrappers become no-ops there.
            nixglPackages =
              if nixpkgs.lib.hasSuffix "-linux" system
              then nixgl.packages.${system}
              else null;
          };
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
