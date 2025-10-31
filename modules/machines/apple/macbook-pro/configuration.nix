{ inputs, pkgs, ... }:
{

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) system config;
      };
    })
  ];

  environment.systemPackages = [
    pkgs.vim
    pkgs.unstable.neovim
    pkgs.devbox
    pkgs.nixfmt-rfc-style
  ];

  fonts = {
    packages = with pkgs; [
      nerdfonts
    ];
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };

    global.autoUpdate = false;

    brews = [
      "bitwarden-cli"
      "openssl@3"
      "ninja"
      "ccache"
      "cmake"
      "pkg-config"
      "huggingface-cli"
      "python"
      # "codex"
    ];

    casks = [
      # Spotlight alternative.
      "raycast"
      # Browser.
      "arc"
      # Music Player.
      "spotify"
      # VPN.
      "tailscale"
      # Password Manager.
      "bitwarden"
      # LLM interface.
      "chatgpt"
      # Messaging.
      "whatsapp"
      # Open Slack alternative based on Matrix.
      "element"
      # Bookmarker.
      "raindropio"
      # Discord messaging
      "discord"
      # C/C++ IDE
      "clion"
      # Rust IDE
      "rustrover"
      # AI IDE based on VS Code.
      "windsurf"
      # Messenger
      "telegram"
      # Knowledge base.
      "obsidian"
      "moonlight"
      "ngrok"
      "arduino-ide"
      "deluge"
      "vlc"
    ];
  };

  system.defaults.dock = {
    autohide = true;
    tilesize = 48;
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
