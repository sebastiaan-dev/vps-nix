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

  fonts.packages = with pkgs; [
nerd-fonts._3270
nerd-fonts.agave
nerd-fonts.anonymice
nerd-fonts.arimo
nerd-fonts.aurulent-sans-mono
nerd-fonts.bigblue-terminal
nerd-fonts.bitstream-vera-sans-mono
nerd-fonts.blex-mono
nerd-fonts.caskaydia-cove
nerd-fonts.caskaydia-mono
nerd-fonts.code-new-roman
nerd-fonts.comic-shanns-mono
nerd-fonts.commit-mono
nerd-fonts.cousine
nerd-fonts.d2coding
nerd-fonts.daddy-time-mono
nerd-fonts.departure-mono
nerd-fonts.dejavu-sans-mono
nerd-fonts.droid-sans-mono
nerd-fonts.envy-code-r
nerd-fonts.fantasque-sans-mono
nerd-fonts.fira-code
nerd-fonts.fira-mono
nerd-fonts.geist-mono
nerd-fonts.go-mono
nerd-fonts.gohufont
nerd-fonts.hack
nerd-fonts.hasklug
nerd-fonts.heavy-data
nerd-fonts.hurmit
nerd-fonts.im-writing
nerd-fonts.inconsolata
nerd-fonts.inconsolata-go
nerd-fonts.inconsolata-lgc
nerd-fonts.intone-mono
nerd-fonts.iosevka
nerd-fonts.iosevka-term
nerd-fonts.iosevka-term-slab
nerd-fonts.jetbrains-mono
nerd-fonts.lekton
nerd-fonts.liberation
nerd-fonts.lilex
nerd-fonts.martian-mono
nerd-fonts.meslo-lg
nerd-fonts.monaspace
nerd-fonts.monofur
nerd-fonts.monoid
nerd-fonts.mononoki
nerd-fonts.noto
nerd-fonts.open-dyslexic
nerd-fonts.overpass
nerd-fonts.profont
nerd-fonts.proggy-clean-tt
nerd-fonts.recursive-mono
nerd-fonts.roboto-mono
nerd-fonts.shure-tech-mono
nerd-fonts.sauce-code-pro
nerd-fonts.space-mono
nerd-fonts.symbols-only
nerd-fonts.terminess-ttf
nerd-fonts.tinos
nerd-fonts.ubuntu
nerd-fonts.ubuntu-mono
nerd-fonts.ubuntu-sans
nerd-fonts.victor-mono
nerd-fonts.zed-mono
  ];

  #fonts = {
  #  packages = with pkgs; [
  #    nerdfonts
  #  ];
  #};

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

  system.primaryUser = "sebastiaan";

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
