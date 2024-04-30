{
  description = "System configurations / Overlays / Applications";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/23.11";
    nur.url = "github:nix-community/NUR/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    supportedSystems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    overlays = [
      inputs.nur.overlay
      self.overlays.default
      inputs.neovim-nightly-overlay.overlay
    ];
    lib = import ./lib {inherit supportedSystems nixpkgs overlays inputs;};
    inherit (lib) forAllSystems nixpkgsFor fromDir;
  in {
    overlays.default = fromDir ./overlay;

    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);

    packages = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in {
        default = inputs.home-manager.defaultPackage.${system};
        nvim = pkgs.nvim;
      }
    );

    # Dev Shells for nix development contains all the required tools.
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nix-prefetch-github
            nixfmt-rfc-style
          ];
          shellHook = "zsh";
        };
      }
    );
  };
}
