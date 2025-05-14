{ config, pkgs, ... }:

{
    # Reference
    # - https://ryantm.github.io/nixpkgs/builders/trivial-builders/#trivial-builder-writeShellApplication
    home.packages = with pkgs; [
        rectangle
	lazygit
        # Cheatsheet
        navi
        # Command runner
        just
        # Task manager
        taskwarrior3
        # Code snippets
        nap
        # Logfile navigator
        lnav
        # Kubernetes cluster manager
        k9s
        # File browser
        nnn
        (writeShellApplication {
            name = "rebuild";
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

                cd ~/vps-nix
                git pull

                if $update_secrets; then
                    nix flake update self-secrets
                fi

                darwin-rebuild switch --flake .;

                if ! git diff --quiet -- flake.lock || ! git diff --cached --quiet -- flake.lock; then
                    git add flake.lock
                    git commit -m "chore: Update flake.lock"
                    git push
                fi
            '';
        })
        (writeShellApplication {
            name = "update";
            runtimeInputs = [
                git
                nix
            ];
            text = ''
                cd ~/vps-nix
                git pull
                nix flake update
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

programs.alacritty = {
	enable = true;
};

programs.tmux = {
	enable = true;
	extraConfig = ''
      # update the env when attaching to an existing session
      set -g update-environment -r

      set -ag terminal-overrides ",alacritty*:Tc,foot*:Tc,xterm-kitty*:Tc,xterm-256color:Tc"

      set -as terminal-features ",alacritty*:RGB,foot*:RGB,xterm-kitty*:RGB"
      set -as terminal-features ",alacritty*:hyperlinks,foot*:hyperlinks,xterm-kitty*:hyperlinks"
      set -as terminal-features ",alacritty*:usstyle,foot*:usstyle,xterm-kitty*:usstyle"

# update the env when attaching to an existing session
set -g update-environment -r

set -ag terminal-overrides ",alacritty*:Tc,foot*:Tc,xterm-kitty*:Tc,xterm-256color:Tc"
# -- display -------------------------------------------------------------------

set -g base-index 1           # start windows numbering at 1
setw -g pane-base-index 1     # make pane numbering consistent with windows
	'';
};

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
    };

    programs.neovim = {
        enable = true;
    };

	# GitHub CLI
	programs.gh = {
		enable = true;
	};

    # Zoxide is a smart cd command that learns your habits
    programs.zoxide.enable = true;

    programs.direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
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
