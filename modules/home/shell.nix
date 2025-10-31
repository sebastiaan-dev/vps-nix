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

      # Inspiration from:
      # https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
      extraConfig = ''
        # Less awkward prefix.
        unbind C-b
        set-option -g prefix C-space
        bind-key C-space send-prefix

        # Easier moving between panes.
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Set new panes to open in current directory
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"

        # Increase tmux messages display duration from 750ms to 4s.
        set -g display-time 4000

        # Refresh 'status-left' and 'status-right' more often, from every 15s to 5s.
        set -g status-interval 5

        # Emacs key bindings in tmux command prompt (prefix + :) are better than
        # vi keys, even for vim users.
        set -g status-keys emacs

        # Focus events enabled for terminals that support them.
        set -g focus-events on

        # Super useful when using "grouped sessions" and multi-monitor setup.
        setw -g aggressive-resize on

        set -as terminal-features ",alacritty*:RGB,foot*:RGB,xterm-kitty*:RGB"
        set -as terminal-features ",alacritty*:hyperlinks,foot*:hyperlinks,xterm-kitty*:hyperlinks"
        set -as terminal-features ",alacritty*:usstyle,foot*:usstyle,xterm-kitty*:usstyle"

        set -g update-environment -r

        set -ag terminal-overrides ",alacritty*:Tc,foot*:Tc,xterm-kitty*:Tc,xterm-256color:Tc"

        # Source .tmux.conf as suggested in `man tmux`.
        bind R source-file '~/.tmux.conf'

        #### THEMING ####
        set -g @mocha-rosewater "#ea6962"
        set -g @mocha-pink      "#d3869b"
        set -g @mocha-mauve     "#d3869b"
        set -g @mocha-peach     "#e78a4e"
        set -g @mocha-yellow    "#d8a657"
        set -g @mocha-green     "#a9b665"
        set -g @mocha-teal      "#89b482"
        set -g @mocha-blue      "#7daea3"
        set -g @mocha-text      "#ebdbb2"
        set -g @mocha-subtext0  "#bdae93"
        set -g @mocha-overlay0  "#595959"
        set -g @mocha-surface0  "#292929"
        set -g @mocha-base      "#1d2021"
        set -g @mocha-mantle    "#191b1c"
        set -g @mocha-crust     "#141617"

        # ─── status bar ──────────────────────────────────────────────────────────────
        set -g status-style           "bg=#{@mocha-base},fg=#{@mocha-text}"
        set -g status-left-style      "bg=#{@mocha-mantle},fg=#{@mocha-peach},bold"
        set -g status-left            "#[nodim] #S #[default]"
        set -g status-right-style     "fg=#{@mocha-teal}"

        # ─── windows ─────────────────────────────────────────────────────────────────
        setw -g window-status-current-style 'fg=black bg=red'
        setw -g window-status-current-format ' #I #W #F '

        setw -g window-status-style 'fg=red bg=black'
        setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

        setw -g window-status-bell-style 'fg=yellow bg=red bold'

        # ─── pane borders ─────────────────────────────────────────────────────────────
        set -g pane-border-style        "fg=#{@mocha-overlay0}"
        set -g pane-active-border-style "fg=#{@mocha-red}"

        # ─── messages (prompts, etc.) ────────────────────────────────────────────────
        set -g message-style          "bg=#{@mocha-surface0},fg=#{@mocha-text}"
        set -g message-command-style  "bg=#{@mocha-surface0},fg=#{@mocha-text}"

        # ─── clock mode ──────────────────────────────────────────────────────────────
        # set -g clock-mode-colour      "#{@mocha-mauve}"
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
          size = if pkgs.stdenv.isDarwin then 13 else 12;

          # Great font options are:
          # FiraCode, RobotoMono, JetBrainsMono
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
        };

        colors = {
          primary = {
            background = "#1d2021"; # mocha.base
            foreground = "#ebdbb2"; # mocha.text
            dim_foreground = "#928374"; # mocha.overlay1
            bright_foreground = "#ebdbb2"; # same as text
          };

          cursor = {
            text = "#1d2021"; # mocha.base
            cursor = "#ea6962"; # mocha.rosewater
          };

          vi_mode_cursor = {
            text = "#1d2021"; # mocha.base
            cursor = "#7daea3"; # mocha.blue
          };

          search = {
            matches = {
              foreground = "#1d2021"; # mocha.base
              background = "#a89984"; # mocha.overlay2
            };

            focused_match = {
              foreground = "#1d2021"; # mocha.base
              background = "#a9b665"; # mocha.green
            };
          };

          footer_bar = {
            foreground = "#1d2021"; # mocha.base
            background = "#a89984"; # mocha.overlay2
          };

          hints = {
            start = {
              foreground = "#1d2021"; # mocha.base
              background = "#d8a657"; # mocha.yellow
            };

            end = {
              foreground = "#1d2021"; # mocha.base
              background = "#a89984"; # mocha.overlay2
            };
          };

          selection = {
            text = "#1d2021"; # mocha.base
            background = "#ea6962"; # mocha.rosewater
          };

          normal = {
            black = "#292929"; # mocha.surface0
            red = "#ea6962"; # mocha.red
            green = "#a9b665"; # mocha.green
            yellow = "#d8a657"; # mocha.yellow
            blue = "#7daea3"; # mocha.blue
            magenta = "#d3869b"; # mocha.pink
            cyan = "#89b482"; # mocha.teal
            white = "#ebdbb2"; # mocha.text
          };

          bright = {
            black = "#4d4d4d"; # mocha.surface2
            red = "#ea6962"; # mocha.red
            green = "#a9b665"; # mocha.green
            yellow = "#d8a657"; # mocha.yellow
            blue = "#7daea3"; # mocha.blue
            magenta = "#d3869b"; # mocha.pink
            cyan = "#89b482"; # mocha.teal
            white = "#a89984"; # mocha.overlay
          };

          indexed_colors = [
            {
              index = 16;
              color = "#e78a4e"; # mocha.peach
            }
            {
              index = 17;
              color = "#ea6962"; # mocha.rosewater
            }
          ];
        };
      };
    };

  };

  # Theming
  catppuccin = {
    enable = false;
    flavor = "mocha";

    fzf.enable = true;
    bat.enable = true;
    starship.enable = true;
    # tmux.enable = true;
    # alacritty.enable = true;
  };
}
