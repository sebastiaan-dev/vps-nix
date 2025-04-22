{ config, pkgs, ... }:

{
    home = {
        username = "sebastiaan";
        homeDirectory = "/home/sebastiaan";
    };

    programs.git = {
        enable = true;
        userName = "Sebastiaan Gerritsen";
        userEmail = "dev@sebastiaan.io";
    };

    programs.starship = {
        enable = true;
    };

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
            rebuild = "(cd /home/sebastiaan/vps-nix && git pull && sudo nixos-rebuild switch --flake .)";
        };
    };

	# GitHub CLI
	programs.gh = {
		enable = true;
	};

    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.11";

    # Let home Manager install and manage itself.
    programs.home-manager.enable = true;
}
