{
disko.devices = {
    disk = {
      system = {
        type = "disk";
        device = "/dev/disk/by-id/virtio-1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "8G";
              content = {
                type = "swap";
                randomEncryption = true;
                discardPolicy = "both";
              };
            };
            root = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "rpool";
              };
            };
          };
        };
      };
    };
    zpool = {
      rpool = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          #canmount = "off";
          xattr = "sa";
          normalization = "formD";
          #mountpoint = "none";
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        options = {
          #ashift = "12";
          autotrim = "on";
        };
        datasets = {
          local = {
            type = "zfs_fs";
            options.mountpoint = "none"; # testing
            options.canmount = "off"; # testing
          };
          safe = {
            type = "zfs_fs";
            options.mountpoint = "none"; # testing
            options.canmount = "off"; # testing
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            postCreateHook = ''
              zfs snapshot rpool/local/root@blank
            '';
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              atime = "off";
              #canmount = "on";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "safe/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options = {
              #canmount = "on";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "safe/steam" = {
            type = "zfs_fs";
            mountpoint = "/mnt/games";
            # Need to target `/mnt` since that is where the initial nixos install happens
            postMountHook = ''
              groupadd -f gaming
              chown -R :gaming /mnt/disko-install-root/mnt/games
              chmod g+rwx /mnt/disko-install-root/mnt/games
              chmod g+s /mnt/disko-install-root/mnt/games
            '';
            options = {
              casesensitivity = "insensitive";
              quota = "1T"; # Steam 0mb available bug
              recordsize = "1M";
            };
          };
          "safe/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
            #canmount = "on";
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };
}
