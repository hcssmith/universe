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

  defaultUsers = pkgs: [
    {
      name = "hcssmith";
      groups = ["wheel" "networkmanager"];
      uid = 1000;
      shell = pkgs.zsh;
    }
  ];

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
    sway ? false,
    ...
  }: let
    pkgs = nixpkgsFor.${system};
    home-modules = import ./home-modules.nix {inherit pkgs lib;};
    inherit (home-modules) utils-module kitty-module zsh-module starship-module git-module sway-module;
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
        (lib.mkIf sway sway-module)
      ];
    };

  mkHost = {
    name,
    users ? null,
    location ? "uk",
    system ? "x86_64-linux",
    extraConfig ? {},
    uefi ? false,
    sound ? false,
    filesystems ? null,
    extraHardwareConfig ? {},
    gui ? false,
    buildIso ? false,
    fonts ? true,
    extraFonts ? [],
    ...
  }: let
    sys_users =
      if (users != null)
      then map (u: mkSystemUser u) users
      else [];
    pkgs = nixpkgsFor.${system};
    nixos-modules = import ./nixos-modules.nix {inherit pkgs;};
    inherit (nixos-modules) uefi-module nix-config sound-module location-uk gdm-module gnome-module dwm-module fonts-module;
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
    isoModules =
      if buildIso == true
      then [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-base.nix"
        {
          isoImage.squashfsCompression = "gzip -Xcompression-level 1";
          services.displayManager.autoLogin = {
            enable = true;
            user = "nixos";
          };
        }
      ]
      else [];
  in
    nixpkgs.lib.nixosSystem {
      inherit system;

      modules =
        [
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
              wireless.enable = false;
            };
            nix = nix-config;
            system.stateVersion = "24.05";
            environment.systemPackages = with pkgs; [
              tabbed
              surf
              st
              dmenu
              slstatus
              slock
            ];
          }
          (lib.mkIf uefi uefi-module)
          (lib.mkIf sound sound-module)
          (lib.mkIf (builtins.isAttrs filesystems) {fileSystems = filesystems;})
          (lib.mkIf (builtins.isPath filesystems) {fileSystems = import filesystems;})
          (lib.mkIf (builtins.isNull filesystems && buildIso == false) {boot.isContainer = true;})
          (lib.mkIf (builtins.isAttrs extraHardwareConfig) extraHardwareConfig)
          (lib.mkIf (location == "uk") location-uk)
          (lib.mkIf (location == "uk" && gui != null) {services.xserver.xkb.layout = "gb";})
          (lib.mkIf (gui != null) gdm-module)
          (lib.mkIf (gui == "gnome") gnome-module)
          (lib.mkIf (gui == "dwm") dwm-module)
          (lib.mkIf fonts fonts-module)
          (lib.mkIf fonts {fonts.packages = extraFonts;})
        ]
        ++ isoModules;
    };
}
