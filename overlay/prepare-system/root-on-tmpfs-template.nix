{
  disko.devices = {
    disk = {
      nodev = {
        "/" = {
          fsType = "tmpfs";
          mountOptions = [
            "size=2G"
            "mode=755"
          ];
        };
      };
      my-disk = {
        device = "/dev/$DISK_NAME";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            nix = {
              size = "60%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/nix";
              };
            };
            home = {
              size = "40%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/home";
              };
            };
          };
        };
      };
    };
  };
}
