{
  supportedSystems,
  nixpkgs,
  overlays,
  inputs,
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

  uefi-module = {
    boot.loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  sound-module = {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  location-uk = {
    console.keyMap = "uk";
    time.timeZone = "Europe/London";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
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
  }: let
    sys_users = map (u: mkSystemUser u) users;
    pkgs = nixpkgsFor.${system};
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
          nix = {
						settings.experimental-features = ["nix-command" "flakes"];
						registry = {
							"universe" = {
								from = {
									id = "universe";
									indirect = true;
								};
								to = {
									owner = "hcssmith";
									repo = "universe";
									type = "github";
								};
								flake = nixpkgs;
								};
						};
					};
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
