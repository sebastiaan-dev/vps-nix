{ config, lib, pkgs, ... }:

{
    imports =
    [
        ./hardware-configuration.nix
        "${ builtins.fetchTarball { url = "https://github.com/nix-community/disko/archive/v1.11.0.tar.gz"; sha256 = "13brimg7z7k9y36n4jc1pssqyw94nd8qvgfjv53z66lv4xkhin92"; } }/module.nix"
        ./disk-config.nix
    ];

    boot = {
      efiSupport = true;
      efiInstallAsRemovable = true;
    };

    systemd.targets.multi-user.enable = true;

    environment.systemPackages = with pkgs; [
        # Add fetching tools
        curl
        wget
    ];

    # Disable autologin.
    services.getty.autologinUser = null;
    # Open ports in the firewall.
    networking = {
        hostName = "net-worker-2";
        # Dynamically configure networking
        networkmanager.enable = true;

        firewall = {
            # Always allow traffic from your Tailscale network
            trustedInterfaces = [ "tailscale0" ];

            # Allow the Tailscale UDP port
            # Allow the DNS UDP port
            # allowedUDPPorts = [ config.services.tailscale.port 53 ];
            # Open up the HTTP and HTTPS ports
            # Allow SSH
            # allowedTCPPorts = [ 22 80 443 ];
        };
    };

    # Temporary SSH key for the server
    users.users.root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEgVZaJkRdvGhG1zbXq0EIyDGItvLql88/cDSEJL2Ry4 dev@sebastiaan.io"
    ];

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