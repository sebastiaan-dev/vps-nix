{ modulesPath, config, lib, pkgs, ... }:

{
    imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      (modulesPath + "/profiles/qemu-guest.nix")
      ./disk-config.nix
    ];

    boot.supportedFilesystems = [ "zfs" ];
    boot.loader.grub.device = "/dev/sdb";
    boot.loader.grub.mirroredBoots = []; 

    systemd.targets.multi-user.enable = true;

    environment.systemPackages = with pkgs; [
        # Add fetching tools
        curl
        wget
    ];

    # 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    # link/ether bc:24:11:88:8b:d1 brd ff:ff:ff:ff:ff:ff
    # altname enp0s18
    # inet 193.32.87.170/24 brd 193.32.87.255 scope global eth0
    #    valid_lft forever preferred_lft forever
    # inet6 2a0d:8143:0:b9::/64 scope global 
    #    valid_lft forever preferred_lft forever
    # inet6 fe80::be24:11ff:fe88:8bd1/64 scope link 
    #    valid_lft forever preferred_lft forever

    # Disable autologin.
    services.getty.autologinUser = null;
    # Open ports in the firewall.
    networking = {
        hostId = "0654186d"; # From head -c 8 /etc/machine-id
        hostName = "net-storage-1";
        
        interfaces = {
          eth0 = {
            ipv4.addresses = [{
                address = "193.32.87.170";
                prefixLength = 24;
            }];
            ipv6.addresses = [{
                address = "2a0d:8143:0:b9::";
                prefixLength = 64;
            }];
          };
        };

        defaultGateway = {
            address = "193.32.87.1";
            interface = "eth0";
        };

        nameservers = ["8.8.8.8" "1.1.1.1"];

        firewall = {
            # Always allow traffic from your Tailscale network
            # trustedInterfaces = [ "tailscale0" ];

            # Allow the Tailscale UDP port
            # Allow the DNS UDP port
            # allowedUDPPorts = [ config.services.tailscale.port 53 ];
            # Open up the HTTP and HTTPS ports
            # Allow SSH
            # allowedTCPPorts = [ 22 80 443 ];
        };
    };

    # This option defines the first version of NixOS you have installed on this particular machine,
    # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
    #
    # Most users should NEVER change this value after the initial install, for any reason,
    # even if you've upgraded your system to a new NixOS release.
    #
    # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
    # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
    # to actually do that.
    #
    # This value being lower than the current NixOS release does NOT mean your system is
    # out of date, out of support, or vulnerable.
    #
    # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
    # and migrated your data accordingly.
    #
    # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
    system.stateVersion = "24.11"; # Did you read the comment?
}