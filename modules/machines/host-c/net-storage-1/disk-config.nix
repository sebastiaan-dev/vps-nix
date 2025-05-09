{ lib, ... }:
{
  disko.devices = {
    disk = {
      disk1 = {
        device = lib.mkDefault "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            esp = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
      disk2 = {
        device = lib.mkDefault "/dev/sda";
        type = "disk";
        content = {
          type = "zfs";
          pool = "zroot";
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        # Workaround: cannot import 'zroot': I/O error in disko tests
        options.cachefile = "none";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        mountpoint = "/mnt/pool";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          "root" = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };

          "root/home" = {
            type = "zfs_fs";
            options."com.sun:auto-snapshot" = "true"; # Snapshots enabled for user data
          };

          "root/persist" = {
            type = "zfs_fs";
            options."com.sun:auto-snapshot" = "true"; # Snapshots enabled for persistent data
          };
        };
      };
    };
  };
}