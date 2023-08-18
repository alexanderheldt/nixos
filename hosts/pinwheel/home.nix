{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  home.username = "alex";
  home.homeDirectory = "/home/alex";

  imports = [
    ./../../modules/firefox
  ];
 
  home.packages = with pkgs; [
    vim
    emacs
    gnumake
    tig
    bemenu
  ];

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "sombrero.local" = {
        hostname = "192.168.50.200";
        user = "alex";
        identityFile = "/home/alex/.ssh/alex.pinwheel-sombrero";
        port = 1122;
      };
      "github.com" = {
        hostname = "github.com";
        identityFile = "/home/alex/.ssh/alex.pinwheel-github.com";
      };
    };
  };

  programs.git = {
    enable = true;
    includes = [
      { path = ./configs/.gitconfig; }
    ];
  };
  
  programs.foot = {
    enable = true;
    
    settings = {
      main = {
        term = "xterm-256color";
        font = "DejaVuSansM Nerd Font Mono:size=10";
      };
    };
  };

  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    
    history = {
      ignoreDups = true;
      size = 100000;
      save = 100000;
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "powerlevel10k-config";
        src = ./configs/p10k-config;
        file = "p10k.zsh";
      }
    ];

    envExtra = lib.strings.concatStringsSep "\n" [
      "EDITOR=vim"
      "BROWSER=firefox"
    ];

    initExtra = lib.strings.concatStringsSep "\n" [
      "export KEYTIMEOUT=1"
      "bindkey -v '^?' backward-delete-char"
      "bindkey '^a' beginning-of-line"
      "bindkey '^e' end-of-line"
    ];
  };

  programs.tmux = {
    enable = true;

    baseIndex = 1;
    keyMode = "vi";

    # Allow vi mode to be enabled instantly
    escapeTime = 0;

    plugins = [
      pkgs.tmuxPlugins.sensible
    ];

    extraConfig = ''
      set -g renumber-windows on

      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides "*:Ss=\E[%p1%d q:Se=\E[ q"
      set-environment -g COLORTERM "truecolor" 
      
      set-option -g allow-rename off

      # Status line colors
      set -g status-fg '#f9c22b'
      set -g status-bg '#303030'

      # Remove date/time etc. on the right side
      set -g status-right ""

      # Status window colors
      set -g window-status-current-style bg='#3a3a3a',fg='#f9c22b'
      set -g window-status-current-style bg='#3a3a3a',fg='#f9c22b'
      set -g window-status-style bg='#303030',fg='#767676'
      
      set -g pane-border-style fg='#3a3a3a'
      set -g pane-active-border-style fg='#f9c22b'
      
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
      
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      
      # Move panes shortcuts
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      
      # Resize panes
      bind -r H resize-pane -L 10
      bind -r J resize-pane -D 10
      bind -r K resize-pane -U 10
      bind -r L resize-pane -R 10
      
      # Move windows
      bind -r Left swap-window -t -1 \; select-window -t -1
      bind -r Right swap-window -t +1 \; select-window -t +1
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland = {
      enable = true;
      hidpi = true;
    };

    extraConfig = ''
      exec-once = waybar 
    '';

    settings = {
      "$mod" = "SUPER";
      
      animations.enabled = false;

      input = {
        kb_layout = "se";

        follow_mouse = 0;
        touchpad = {
          natural_scroll = false;
          tap-and-drag = false;
        };
      };

      general = {
        gaps_in = 0;  # gaps between windows
        gaps_out = 0; # gaps between windows and monitor edges

        layout = "dwindle";
      };

      dwindle = {
        force_split = 2;
        no_gaps_when_only = 1;
      };

      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };
 
      bind = let 
        ws = x:
          let n = if (x + 1) < 10
            then (x + 1)
            else 0;
          in
            builtins.toString n;

        select = builtins.genList (x: "$mod, ${ws x}, workspace, ${builtins.toString (x + 1)}") 10;
        move = builtins.genList (x: "$mod SHIFT, ${ws x}, movetoworkspacesilent, ${builtins.toString (x + 1)}") 10;
      in 
      select ++ move ++ [
        "$mod, x, exec, swaylock"
        "$mod SHIFT, x, exec, systemctl suspend"

        "$mod, RETURN, exec, foot"
        "$mod, SPACE, exec, bemenu-run" 

        "$mod, ESCAPE, killactive"  

        "$mod, f, fullscreen, 1"
        "$mod SHIFT, f, togglefloating, active"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
      ];

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"   # left click
        "$mod, mouse:273, resizewindow" # right click
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
    };
  };

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/hello-from-waybar" ];
        modules-right = [ ];
    
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
    };

   style = '''';

  programs.swaylock = {
    enable = true;

    settings = {
      color = "000000";
      indicator-idle-visible = false;
      show-failed-attempts = true;
    };
  };

  services.dunst.enable = true;

  home.stateVersion = "23.05";
}
