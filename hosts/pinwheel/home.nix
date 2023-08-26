{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  home.username = "alex";
  home.homeDirectory = "/home/alex";
 
  home.packages = with pkgs; [
    emacs
    gnumake
    tig
    bemenu
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    xwayland = {
      enable = true;
    };

    extraConfig = ''
      exec-once = waybar

      monitor=eDP-1, 1920x1200@60, 0x0, 1
      env = GDK_DPI_SCALE,1.5
      env = XCURSOR_SIZE,64
    '';

    settings = {
      "$mod" = "SUPER";
      
      animations.enabled = false;

      xwayland = {
        force_zero_scaling = true;
      };

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
        "$mod, x, exec, ${pkgs.swaylock}/bin/swaylock"
        "$mod SHIFT, x, exec, systemctl suspend"

        "$mod, SPACE, exec, bemenu-run --fn 'DejaVuSansM Nerd Font Mono 14'" 

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
