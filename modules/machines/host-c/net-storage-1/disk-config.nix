{ lib, ... }:
{
  disko.devices = {
    disk = {
      main = {
        device = "/dev/sdb";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            root = {
              end = "-1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            plainSwap = {
              size = "100%";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true; # resume from hiberation from this device
              };
            };
          };
        };
      };
      data = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "zfs";
          pool = "zroot";
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
            options.mountpoint = "/mnt/home";
            options."com.sun:auto-snapshot" = "true"; # Snapshots enabled for user data
          };

          "root/persist" = {
            type = "zfs_fs";
            options.mountpoint = "/mnt/persist";
            options."com.sun:auto-snapshot" = "true"; # Snapshots enabled for persistent data
          };
        };
      };
    };
  };
}