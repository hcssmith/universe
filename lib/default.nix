{
  supportedSystems,
  nixpkgs,
  overlays,
  inputs,
  ...
}: let
  lib = nixpkgs.lib;
in rec {
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

  nixpkgsFor = forAllSystems (
    system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = overlays;
      }
  );

  genOverlay = dir: final: prev: (
    nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir dir)) (
      name: prev.callPackage /${dir}/${name} {inherit prev inputs;}
    )
  );

  overlayToPackages = dir: pkgs:
    nixpkgs.lib.genAttrs (builtins.attrNames (builtins.readDir dir)) (
      name: pkgs.${name}
    );

  mkHMUser = {
    username,
    system,
    extraPackages ? [],
		util ? false,
		kitty ? false,
		zsh ? false,
		starship ? false,
		git ? false,
    ...
  }: let
    pkgs = nixpkgsFor.${system};
    home-modules = import ./home-modules.nix {inherit pkgs lib;};
		inherit (home-modules) utils-module kitty-module zsh-module starship-module git-module;
    nixos-modules = import ./nixos-modules.nix {inherit pkgs;};
    inherit (nixos-modules) nix-config;
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {
          home = {
            inherit username;
            homeDirectory = "/home/${username}";
						stateVersion = "24.05";
            packages = with pkgs; [
              gnutar
              p7zip
              nvim
            ];
          };
          news.display = "silent";
          nix = nix-config;
        }
        {
          home.packages = extraPackages;
        }
				(lib.mkIf util utils-module)
				(lib.mkIf kitty kitty-module)
				(lib.mkIf starship starship-module)
				(lib.mkIf zsh zsh-module)
				(lib.mkIf git git-module)
      ];
    };

  mkHost = {
    name,
    users,
    location ? "uk",
    system ? "x86_64-linux",
    extraConfig ? {},
    uefi ? false,
    sound ? true,
    filesystems ? null,
    extraHardwareConfig ? {},
    ...
  }: let
    sys_users = map (u: mkSystemUser u) users;
    pkgs = nixpkgsFor.${system};
    nixos-modules = import ./nixos-modules.nix {inherit pkgs;};
    inherit (nixos-modules) uefi-module nix-config sound-module location-uk;
    mkSystemUser = {
      name,
      groups,
      uid,
      shell,
      ...
    }: {
      programs.zsh.enable =
        if shell == pkgs.zsh
        then true
        else false;
      users.users."${name}" = {
        name = name;
        isNormalUser = true;
        isSystemUser = false;
        extraGroups = groups;
        uid = uid;
        initialPassword = "Welcome1";
        shell = shell;
      };
    };
  in
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        extraConfig
        {
          imports =
            [
              (lib.mkIf (builtins.isPath extraHardwareConfig) extraHardwareConfig)
            ]
            ++ sys_users;
          nixpkgs.pkgs = pkgs;
          networking = {
            hostName = "${name}";
            networkmanager.enable = true;
          };
          nix = nix-config;
          system.stateVersion = "24.05";
        }
        (lib.mkIf uefi uefi-module)
        (lib.mkIf sound sound-module)
        (lib.mkIf (builtins.isAttrs filesystems) {fileSystems = filesystems;})
        (lib.mkIf (builtins.isPath filesystems) {fileSystems = import filesystems;})
        (lib.mkIf (builtins.isNull filesystems) {boot.isContainer = true;})
        (lib.mkIf (builtins.isAttrs extraHardwareConfig) extraHardwareConfig)
        (lib.mkIf (location == "uk") location-uk)
      ];
    };
}
