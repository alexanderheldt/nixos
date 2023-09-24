{ pkgs, ... }:
{
  home-manager.users.alex = {
    wayland.windowManager.hyprland = {
      enable = true;

      xwayland = {
        enable = true;
      };

      extraConfig = ''
        exec-once=waybar

        monitor=eDP-1, 1920x1200@60, 0x0, 1
        env = GDK_DPI_SCALE,1.5
        env = XCURSOR_SIZE,64

        workspace = 1, monitor:HDMI-A-1
        workspace = 2, monitor:HDMI-A-1
        workspace = 3, monitor:HDMI-A-1
        workspace = 4, monitor:HDMI-A-1
        workspace = 5, monitor:HDMI-A-1
        workspace = 6, monitor:eDP-1
        workspace = 7, monitor:eDP-1
        workspace = 8, monitor:eDP-1
        workspace = 9, monitor:eDP-1
        workspace = 10, monitor:eDP-1
      '';

      settings = {
        "$mod" = "SUPER";

        animations.enabled = false;

        xwayland = {
          force_zero_scaling = true;
        };

        input = {
          kb_layout = "se";

          # 2 - Cursor focus will be detached from keyboard focus. Clicking on a window will move keyboard focus to that window.
          follow_mouse = 2;

          sensitivity = 0.30;
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

          magnifier = pkgs.writeShellScript "magnifier" ''
            CURRENT=$(${pkgs.hyprland}/bin/hyprctl getoption misc:cursor_zoom_factor -j | jq .float)
            DELTA=0.1

            UPDATED=1
            case $1 in
              --increase)
                UPDATED=$(echo $CURRENT + $DELTA | ${pkgs.bc}/bin/bc) ;;
              --decrease)
                UPDATED=$(echo $CURRENT - $DELTA | ${pkgs.bc}/bin/bc) ;;
              --reset)
                UPDATED=1
            esac

            if (( $(echo "$UPDATED < 1" | bc) )); then UPDATED=1; fi
            ${pkgs.hyprland}/bin/hyprctl keyword misc:cursor_zoom_factor $UPDATED
          '';
        in
        select ++ move ++ [
          "$mod SHIFT, x, exec, systemctl suspend"

          "$mod, ESCAPE, killactive"

          "$mod, f, fullscreen, 1"
          "$mod SHIFT, f, togglefloating, active"

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          "$mod SHIFT_CONTROL, 1, exec, ${magnifier} --increase"
          "$mod SHIFT_CONTROL, 2, exec, ${magnifier} --decrease"
          "$mod SHIFT_CONTROL, 3, exec, ${magnifier} --reset"
        ];

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"   # left click
          "$mod, mouse:273, resizewindow" # right click
        ];

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          cursor_zoom_factor = 1;
          cursor_zoom_rigid = true;
        };
      };
    };

    home.packages = [ pkgs.jq pkgs.bc ];
  };
}
