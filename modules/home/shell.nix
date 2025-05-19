{ config, pkgs, ... }:
{

  programs = {
    # Fuzzy finder.
    fzf = {
      enable = true;

      defaultCommand = "batgrep --column --line-number --no-heading --ignore-case --no-ignore --files --hidden --exclude .git";
    };

    # Zoxide is a smart cd command that learns your habits.
    zoxide = {
      enable = true;

      # Hijack the cd command by wrapping it with Zoxide functionality.
      options = [
        "--cmd cd"
      ];
    };

    # Better ls.
    eza = {
      enable = true;
    };

    bat = {
      enable = true;

      extraPackages = with pkgs.bat-extras; [
        # Parse Git diffs.
        batdiff
        # Syntax highlighted man pages.
        batman
        # Syntax highlighted ripgrep.
        batgrep
        # Formatted watch output.
        batwatch
      ];
    };

    # Autoload environments based on the directory.
    # Uses .envrc files.
    direnv = {
      enable = true;

      enableZshIntegration = true;
      # Faster, no GC for build cache (yay for no WiFi zones).
      nix-direnv.enable = true;
    };

    starship = {
      enable = true;
    };

    # Directory navigator.
    broot = {
      enable = true;

      enableZshIntegration = true;
    };

    # Shell and interpreter.
    zsh = {
      enable = true;

      # Profile shell startup timings.
      # zprof.enable = true;

      enableCompletion = false;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        # When pruning remove duplicates to retain unique entries.
        expireDuplicatesFirst = true;
        # Remove older equal commands when new command enters history list.
        ignoreAllDups = true;
      };

      initExtraFirst = '''';

      shellAliases = {
        # Overwrite cd with Zoxide.
        z = "cd";
        # Simulate the existence of ripgrep.
        rg = "batgrep";
        # Overwrite default man command.
        man = "batman";
        ll = "eza -l --group-directories-first --git";
        la = "eza -la --group-directories-first --git";
      };

      initExtra = ''
        export FZF_DEFAULT_COMMAND='batgrep --files --hidden --glob "!.git/*" --glob "!node_modules/*" --ignore-case'

        # FZF-Tab only affects ZSH completions


        # Use tmux popup for fzf-tab
        # zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
        # set list-colors to enable filename colorizing
        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
        # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
        zstyle ':completion:*' menu no
        # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
        zstyle ':fzf-tab:*' use-fzf-default-opts yes

        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1a --color=always --icons=auto $realpath'
        zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

      '';

      antidote = {
        enable = true;
        useFriendlyNames = true;

        plugins = [
          "Aloxaf/fzf-tab"
        ];
      };
    };

    # Terminal multiplexer, saves state when disconnecting from remote machines.
    tmux = {
      enable = true;
      # 0 is further from other numbers.
      baseIndex = 1;
      # Do not use AM/PM.
      clock24 = true;
      escapeTime = 10;
      # Disable unmaintained sensible defaults which crash on MacOS,
      # configure manually instead.
      sensibleOnTop = false;
      historyLimit = 10000;
      terminal = "screen-256color";

      plugins = with pkgs.tmuxPlugins; [
        # Fuzzy find sessions, windows, panes and more (Prefix + Shift + F).
        tmux-fzf
        # Fuzzy select text (Prefix + Tab).
        extrakto
      ];

      extraConfig = ''
        # Increase tmux messages display duration from 750ms to 4s
        set -g display-time 4000

        # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s
        set -g status-interval 5

        # Emacs key bindings in tmux command prompt (prefix + :) are better than
        # vi keys, even for vim users
        set -g status-keys emacs

        # Focus events enabled for terminals that support them
        set -g focus-events on

        # Super useful when using "grouped sessions" and multi-monitor setup
        setw -g aggressive-resize on

        set -as terminal-features ",alacritty*:RGB,foot*:RGB,xterm-kitty*:RGB"
        set -as terminal-features ",alacritty*:hyperlinks,foot*:hyperlinks,xterm-kitty*:hyperlinks"
        set -as terminal-features ",alacritty*:usstyle,foot*:usstyle,xterm-kitty*:usstyle"

        set -g update-environment -r

        set -ag terminal-overrides ",alacritty*:Tc,foot*:Tc,xterm-kitty*:Tc,xterm-256color:Tc"

        # Source .tmux.conf as suggested in `man tmux`
        bind R source-file '~/.tmux.conf'
      '';
    };

    # Terminal emulator
    alacritty = {
      enable = true;

      settings = {
        general = {
          live_config_reload = true;
        };

        terminal = {
          shell.program = "zsh";
          shell.args = [
            "-l"
            "-c"
            "tmux attach || tmux "
          ];
        };

        env = {
          TERM = "xterm-256color";
        };

        window = {
          decorations = if pkgs.stdenv.isDarwin then "buttonless" else "none";
          dynamic_title = false;
          dynamic_padding = true;
          dimensions = {
            columns = 170;
            lines = 45;
          };
          padding = {
            x = 5;
            y = 1;
          };
        };

        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        font = {
          size = if pkgs.stdenv.isDarwin then 12 else 12;

        };
      };
    };

  };

  # Theming
  catppuccin = {
    enable = true;
    flavor = "mocha";

    fzf.enable = true;
    bat.enable = true;
    starship.enable = true;
    # zsh-syntax-highlighting.enable = true;
    tmux.enable = true;
    alacritty.enable = true;
  };
}
