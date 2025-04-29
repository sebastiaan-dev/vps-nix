{ config, pkgs, ... }:

{
    home = {
        username = "sebastiaan";
        homeDirectory = "/home/sebastiaan";
    };

    home.packages = with pkgs; [ 
        (writeShellApplication {
            name = "rebuildv2";
            runtimeInputs = [
                git
                nix
            ];
            text = ''
                update_secrets=false

                if [[ "''${1:-}" == "--update" ]]; then
                    update_secrets=true
                    shift
                fi

                cd /home/sebastiaan/vps-nix
                git pull

                if $update_secrets; then
                    nix flake lock --update-input self-secrets
                fi

                nixos-rebuild switch --flake .;

                if ! git diff --quiet -- flake.lock || ! git diff --cached --quiet -- flake.lock; then
                    git add flake.lock
                    git commit -m "chore: Update flake.lock"
                    git push
                fi
            '';
        })
    ];

    

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
            update = "(cd /home/sebastiaan/vps-nix && git pull && sudo nix flake update)";
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
