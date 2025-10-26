{
  disko.devices = {
    disk.nix = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-KINGSTON_OM8SEP41024Q-A0_50026B7686814B14";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "luks";
              name = "nixcrypt";
              settings.allowDiscards = true;
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                subvolumes = {
                  "nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress-force=zstd:1"
                      "noatime"
                    ];
                  };
                  "swap" = {
                    mountpoint = "/.swap";
                    mountOptions = [
                      "compress-force=zstd:1"
                      "noatime"
                    ];
                    swap.swapfile.size = "8G";
                  };
                };
              };
            };
          };
        };
      };
    };

    disk.home = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_2TB_S6S2NS0TA52470B";
      content = {
        type = "luks";
        name = "homecrypt";
        settings.allowDiscards = true;
        # initrdUnlock = false; # don't unlock at boot
        content = {
          type = "btrfs";
          extraArgs = ["-f"];
          subvolumes = {
            "home" = {
              mountpoint = "/nix/persist/home";
              mountOptions = [
                "compress-force=zstd:1"
                "noatime"
              ];
            };
          };
        };
      };
    };

    disk.games = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-CT4000T700SSD3_2339E879638C";
      content = {
        type = "btrfs";
        extraArgs = ["-f"];
        subvolumes = {
          "home" = {
            mountpoint = "/nix/persist/games";
            mountOptions = [
              "compress-force=zstd:1"
              "noatime"
            ];
          };
        };
      };
    };

    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "defaults"
        "size=6G"
        "mode=755"
      ];
    };
  };
}
