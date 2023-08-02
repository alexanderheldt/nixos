{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  home.username = "alex";
  home.homeDirectory = "/home/alex";

  home.packages = with pkgs; [
    vim
    emacs
    gnumake
    tig
    firefox-devedition-unwrapped
    bemenu
  ];

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
        font = "DejaVuSansM Nerd Font Mono";
      };
    };
  };

  programs.zsh = {
    enable = true;
  };

  programs.tmux = {
    enable = true;

    #shell = "\${pkgs.zsh}/bin/zsh";
    baseIndex = 1;
    # keyMode = "vi";

    extraConfig = ''
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
      
      #bind r source-file ~/.tmux.conf \; display "Config reloaded"
      
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
        "$mod, RETURN, exec, foot"
        "$mod, SPACE, exec, bemenu-run" 

        "$mod, ESCAPE, killactive"  

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
      ];

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
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
  };

  home.stateVersion = "23.05";
}
