{ config, pkgs, ... }:

{

  # Reference
  # - https://ryantm.github.io/nixpkgs/builders/trivial-builders/#trivial-builder-writeShellApplication
  home.packages = with pkgs; [
    # Fast text search
    ripgrep
    devenv
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
    # CLI benchmarking
    hyperfine
    # CLI Markdown renderer
    glow
    zotero
    # VM/container managers
    colima
    docker
    docker-buildx
    nmap
    (writeShellApplication {
      name = "rebuild";
      runtimeInputs = [
        git
        nix
        coreutils
        util-linux
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

        # FIXME: Requires root.
        darwin-rebuild switch --flake .;

        if ! git diff --quiet -- flake.lock || ! git diff --cached --quiet -- flake.lock; then
          add flake.lock
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

  programs = {
    # Resource monitor.
    btop = {
      enable = true;
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
