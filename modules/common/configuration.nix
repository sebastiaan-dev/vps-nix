{ config, lib, pkgs, ... }:

{
    # Enable flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Give administators sudo access without password
    security.sudo = {
	    wheelNeedsPassword = false;
    };

    # Currently do not enable the firewall
    networking.firewall.enable = false;

    # User configuration
    users.users = {
        # Personal account
        sebastiaan = {
            isNormalUser = true;
            description = "sebastiaan";
            # Add user to administator group
            extraGroups = [ "wheel" ];
            openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIUSG/ia0YSR8FYClJuu8ZBRp7uut/EhLaAhjHfOQkSZ6S7DeE+oJ15/Qeeo1ES04Ks7ugO3sudfPL3VUh1zq4e7e6zKiSQsOPj3onBA3fjaWuv/N40uVE3+gscM82ObE5Q9Q4KbLuJLJv1EOQNja/FJ2yyp3Ujt5/hkAbqi29RoVZvb59qbTTtDQ3MWflj6KeZg7JgKgfb13UifV+a52FrVsf5HB7KIGCjlc6OQk5iRJHoWuQXY3lNzNLdJF53n2ynEyvRBD6f7R03A4jW02KxYvKNwekCUhdcD/AtrpWub5QzjnvEtSe+U9D5DxPfrcI26a2ewlye2jUszl/4BN4MrZ0D+zXwu7a56x9xOffrMST3AYcgO2BIfolgzZLVsjpSM1I0uKTJRfeLbzqwqFaA4skEFUOwlfy8XFYRMJaUx/+Vq8d4KYjmpQuYKJsKm8Memn+ihjJM6i99EQkweu5Ox3W3tzWdyH1T8yJdOFh+8MBq6eeJIxLnv85g0VAH/M= sebastiaan@Sebastiaans-MacBook-Pro.local"
            ];
            packages = with pkgs; [ ];
        };

        kubernetes = {
            isNormalUser = true;
            description = "kubernetes";
            # Add user to administator group
            extraGroups = [ "wheel" ];
            openssh.authorizedKeys.keys = [
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIUSG/ia0YSR8FYClJuu8ZBRp7uut/EhLaAhjHfOQkSZ6S7DeE+oJ15/Qeeo1ES04Ks7ugO3sudfPL3VUh1zq4e7e6zKiSQsOPj3onBA3fjaWuv/N40uVE3+gscM82ObE5Q9Q4KbLuJLJv1EOQNja/FJ2yyp3Ujt5/hkAbqi29RoVZvb59qbTTtDQ3MWflj6KeZg7JgKgfb13UifV+a52FrVsf5HB7KIGCjlc6OQk5iRJHoWuQXY3lNzNLdJF53n2ynEyvRBD6f7R03A4jW02KxYvKNwekCUhdcD/AtrpWub5QzjnvEtSe+U9D5DxPfrcI26a2ewlye2jUszl/4BN4MrZ0D+zXwu7a56x9xOffrMST3AYcgO2BIfolgzZLVsjpSM1I0uKTJRfeLbzqwqFaA4skEFUOwlfy8XFYRMJaUx/+Vq8d4KYjmpQuYKJsKm8Memn+ihjJM6i99EQkweu5Ox3W3tzWdyH1T8yJdOFh+8MBq6eeJIxLnv85g0VAH/M= sebastiaan@Sebastiaans-MacBook-Pro.local"
            ];
            packages = with pkgs; [ ];
        };
    };

    services = {
        # Enable the OpenSSH daemon.
        openssh = {
            enable = true;
            settings = {
                # The root user should not be accesible via SSH
                PermitRootLogin = "no";
                # Only allow public key authentication
                PasswordAuthentication = false;        
            };
        };
    };

    # Global system packages
    environment.systemPackages = with pkgs; [
        # Editor
        vim
        # Version control
        git
    ];
}