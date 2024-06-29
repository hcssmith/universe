{pkgs, ...}: rec {
  uefi-module = {
    boot.loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  registry = {
    "universe" = {
      from = {
        id = "universe";
        type = "indirect";
      };
      to = {
        owner = "hcssmith";
        repo = "universe";
        type = "github";
      };
    };
  };

  nix-config = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    registry = registry;
    package = pkgs.nix;
  };

  sound-module = {
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  location-uk = {
    console.keyMap = "uk";
    time.timeZone = "Europe/London";
    i18n.extraLocaleSettings = {
      defaultLocale = "en_GB.UTF-8";
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

  gdm-module = {
    services.xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
      };
    };
  };

  gnome-module = {
    services.xserver.desktopManager.gnome = {
      enable = true;
    };
  };

  dwm-module = {
    services.xserver.windowManager.dwm = {
      package = pkgs.dwm;
      enable = true;
    };
  };

  fonts-module = {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        fira-code-nerdfont
        source-code-pro
      ];
    };
  };
}
