{
  description = "System configurations / Overlays / Applications";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/23.11";
    nur.url = "github:nix-community/NUR/master";
    nixgl.url = "github:nix-community/nixGL";
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
      inputs.nixgl.overlay
    ];
    lib = import ./lib {inherit supportedSystems nixpkgs overlays inputs;};
    inherit (lib) forAllSystems nixpkgsFor overlayToPackages genOverlay mkHost mkHMUser;
  in {
    nixosConfigurations = {
      laptop = let
        system = "x86_64-linux";
        pkgs = nixpkgsFor.${system};
      in
        mkHost {
          name = "laptop";
          inherit system;
          users = [
            {
              name = "hcssmith";
              groups = ["wheel" "networkmanager"];
              uid = 1000;
              shell = pkgs.zsh;
            }
          ];
        };
    };

    homeConfigurations = {
      hcssmith = let
        system = "x86_64-linux";
        pkgs = nixpkgsFor.${system};
      in
        mkHMUser {
          username = "hcssmith";
          inherit system;
          kitty = true;
          starship = true;
          git = true;
          util = true;
          zsh = true;
          extraPackages = with pkgs; [
            firefox
            nixgl.nixGLIntel
          ];
        };
    };

    overlays.default = genOverlay ./overlay;

    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);

    packages = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in
        {
          default = inputs.home-manager.defaultPackage.${system};
        }
        // (overlayToPackages ./overlay pkgs)
    );

    # Dev Shells for nix development contains all the required tools.
    devShells = forAllSystems (
      system: let
        pkgs = nixpkgsFor.${system};
      in {
        default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            nix-prefetch-github
          ];
          shellHook = "zsh";
        };
      }
    );
  };
}
