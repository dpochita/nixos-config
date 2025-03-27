{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/nvme0n1";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "32GiB";
              content = {
                type = "swap";
                randomEncryption = true;
                priority = 100; # prefer to encrypt as long as we have space for it
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          dnodesize = "auto";
          canmount = "off";
          xattr = "sa";
          relatime = "on";
          normalization = "formD";
          mountpoint = "none";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/pass-zpool-zroot";
          compression = "lz4";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = ''
          zfs set keylocation="prompt" zroot
        '';
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          "local" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          # ZFS's performance will deteriorate significantly when more than 80% of the available space is used
          # - to avoid this, reserve disk space beforehand.
          "local/reserved" = {
            type = "zfs_fs";
            options = {
              reservation = "10GiB";
            };
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/local/root@blank$' || zfs snapshot zroot/local/root@blank";
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              atime = "off";
              mountpoint = "legacy";
              encryption = "off";
            };
          };
          "local/persist" = {
            type = "zfs_fs";
            mountpoint = "/persist";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
          "local/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options = {
              mountpoint = "legacy";
              "com.sun:auto-snapshot" = "true";
            };
          };
        };
      };
    };
  };
}
