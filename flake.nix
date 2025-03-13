{
  description = "System configurations / Overlays / Applications";

  inputs = {
    #nixpkgs.url = "git+file:///home/hcssmith/Projects/nixpkgs";
    #nixpkgs.url = "github:hcssmith/nixpkgs";
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    nixpkgs_stable.url = "github:nixos/nixpkgs/23.11";
    nur.url = "github:nix-community/NUR/master";
    nixgl.url = "github:nix-community/nixGL";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:hcssmith/neovim.drv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tmux = {
      url = "github:hcssmith/tmux.drv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nushell = {
      url = "github:hcssmith/nushell.drv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:hcssmith/wezterm.drv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    picom = {
      url = "github:hcssmith/picom.drv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plan9 = {
      url = "github:hcssmith/plan9.drv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: let
    supportedSystems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    overlays = [
      inputs.nur.overlay
      inputs.nixgl.overlay
      inputs.neovim.overlays.default
      inputs.tmux.overlays.default
      inputs.nushell.overlays.default
      inputs.wezterm.overlays.default
      inputs.picom.overlays.default
      inputs.plan9.overlays.default
    ];
    lib = import ./lib {inherit supportedSystems nixpkgs overlays inputs;};
    inherit (lib) forAllSystems nixpkgsFor mkHost mkHMUser defaultUsers;
  in rec {
    supportedSystems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    nixosConfigurations = {
      laptop = let
        system = "x86_64-linux";
        pkgs = nixpkgsFor.${system};
      in
        mkHost {
          name = "laptop";
          inherit system;
          location = "uk";
          gui = "gnome";
          uefi = true;
          sound = true;
          users = defaultUsers pkgs;
        };
      x86_64_buildIso = let
        system = "x86_64-linux";
      in
        mkHost {
          name = "x86_64_buildIso";
          inherit system;
          buildIso = true;
          location = "uk";
          gui = "dwm";
        };
    };

    isos = {
      x86 = nixosConfigurations.x86_64_buildIso.config.system.build.isoImage;
    };

    homeConfigurations = {
      hcssmith = let
        system = "x86_64-linux";
        pkgs = nixpkgsFor.${system};
      in
        mkHMUser {
          username = "hcssmith";
          inherit system;
          git = true;
          util = true;
          extraPackages = with pkgs; [
            nixgl.nixGLIntel
            steam-run
            tmux
            wezterm
            picom
            plan9
            plan9port
          ];
        };
    };

    formatter = forAllSystems (system: nixpkgsFor.${system}.alejandra);

    packages = forAllSystems (
      system: {
        default = inputs.home-manager.packages.${system}.default;
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
          ];
          shellHook = "nu";
        };
      }
    );
  };
}
