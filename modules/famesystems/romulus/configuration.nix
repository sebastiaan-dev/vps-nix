# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "romulus"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

security.sudo = {
	wheelNeedsPassword = false;
};
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
networking = {
	interfaces.ens18 = {
		ipv4.addresses = [{
			address = "5.180.254.234";
			prefixLength  = 27;
		}];
	};
	defaultGateway = {
		address = "5.180.254.225";
		interface = "ens18";
	};

	nameservers = ["8.8.8.8" "1.1.1.1"];
};
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;


  

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
users.users.sebastiaan = {
    isNormalUser = true;
    description = "sebastiaan";
    extraGroups = [ "wheel" ];
    openssh.authorizedKeys.keys = [
        # Replace with your own public key
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIUSG/ia0YSR8FYClJuu8ZBRp7uut/EhLaAhjHfOQkSZ6S7DeE+oJ15/Qeeo1ES04Ks7ugO3sudfPL3VUh1zq4e7e6zKiSQsOPj3onBA3fjaWuv/N40uVE3+gscM82ObE5Q9Q4KbLuJLJv1EOQNja/FJ2yyp3Ujt5/hkAbqi29RoVZvb59qbTTtDQ3MWflj6KeZg7JgKgfb13UifV+a52FrVsf5HB7KIGCjlc6OQk5iRJHoWuQXY3lNzNLdJF53n2ynEyvRBD6f7R03A4jW02KxYvKNwekCUhdcD/AtrpWub5QzjnvEtSe+U9D5DxPfrcI26a2ewlye2jUszl/4BN4MrZ0D+zXwu7a56x9xOffrMST3AYcgO2BIfolgzZLVsjpSM1I0uKTJRfeLbzqwqFaA4skEFUOwlfy8XFYRMJaUx/+Vq8d4KYjmpQuYKJsKm8Memn+ihjJM6i99EQkweu5Ox3W3tzWdyH1T8yJdOFh+8MBq6eeJIxLnv85g0VAH/M= sebastiaan@Sebastiaans-MacBook-Pro.local"
    ];
    packages = with pkgs; [
      git
      vim
      code-server
    ];
  };
  # Enable the OpenSSH daemon.
 services.openssh = {
	enable = true;
	settings = {
		PermitRootLogin = "no";
		PasswordAuthentication = false;
	};
};
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
 networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

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