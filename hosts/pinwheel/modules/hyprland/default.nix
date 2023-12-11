{ pkgs, lib, config, ... }:
let
  enabled = config.mod.hyprland.enable;
in
{
  options = {
    mod.hyprland = {
      enable = lib.mkEnableOption "enable hyprland module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      wayland.windowManager.hyprland = {
        enable = true;

        xwayland = {
          enable = true;
        };

        extraConfig = ''
          exec-once=waybar

          env = GDK_DPI_SCALE,1.5
          env = XCURSOR_SIZE,64

          monitor=eDP-1, 1920x1200, 0x0, 1

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

          exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
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
            layout = "dwindle";

            gaps_in = 0;  # gaps between windows
            gaps_out = 0; # gaps between windows and monitor edges

            "col.active_border" = "rgba(${config.lib.colors.foreground}ff)";
            "col.inactive_border" = "rgba(${config.lib.colors.background}ff)";
          };

          dwindle = {
            force_split = 2;
            no_gaps_when_only = 1;
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

      home.packages = [
        pkgs.wdisplays
        pkgs.bc
      ];
    };


    # The XDG portal is needed for screen sharing
    xdg.portal = {
      enable = true;

      # override "trace: warning: xdg-desktop-portal 1.17 reworked how portal implementations are loaded ..."
      config.common.default = "*";

      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # openGL is needed for wayland/hyprland
    hardware.opengl.enable = true;

    systemd.user.services.hyprland-monitors = {
      # systemctl --user restart hyprland-monitors.service
      # journalctl --user -u hyprland-monitors.service -e -f
      unitConfig = {
        Description = "handles hyprland monitor connect/disconnect";
      };

      wantedBy = [ "graphical-session.target" ];
      requires = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];

      path = [
        pkgs.hyprland
        pkgs.socat
        pkgs.jq
        pkgs.bc
        pkgs.libnotify
      ];

      script = let
        moveWSToMonitor = monitor: first: last:
          if last < first
          then throw "'first' has to be less than or equal to 'last'"
          else
            builtins.genList (n: "dispatch moveworkspacetomonitor ${builtins.toString (first + n)} ${monitor}") (last - first + 1);

        external = moveWSToMonitor "HDMI-A-1" 1 5;
        internal = moveWSToMonitor "eDPI-1" 6 10;
        onlyInternal = moveWSToMonitor "eDPI-1" 1 10;
      in
      ''
        update() {
          # waybar is buggy and duplicates workspaces somtimes
          pkill waybar && waybar & disown

          HDMI_STATUS=$(cat /sys/class/drm/card0-HDMI-A-1/status)

          INTERNAL_WIDTH=1920
          INTERNAL_HEIGHT=1200

          if [ $HDMI_STATUS = "connected" ]; then
            notify-send "Using external and laptop monitor"

            hyprctl keyword monitor HDMI-A-1,preferred,0x0,1

            HDMI=$(hyprctl monitors -j | jq '.[] | select(.name=="HDMI-A-1")')
            HDMI_WIDTH=$(echo $HDMI | jq .width)
            HDMI_HEIGHT=$(echo $HDMI | jq .height)

            INTERNAL_POS_X=$(echo "($HDMI_WIDTH - $INTERNAL_WIDTH) / 2" | bc)
            if (( $(echo "$INTERNAL_POS_X < 0" | bc) )); then INTERNAL_POS_X=0; fi
            INTERNAL_POS_Y=$HDMI_HEIGHT

            hyprctl keyword monitor eDP-1,$INTERNAL_WIDTH"x"$INTERNAL_HEIGHT,$INTERNAL_POS_X"x"$INTERNAL_POS_Y,1
            hyprctl --batch "${lib.strings.concatStringsSep ";" (external ++ internal)}"
          else
            notify-send "Using only laptop monitor"

            hyprctl --batch "keyword monitor HDMI-A,disable; keyword monitor eDP-1,$INTERNAL_WIDTH"x"$INTERNAL_HEIGHT,0x0,1"
            hyprctl --batch "${lib.strings.concatStringsSep ";" onlyInternal}"
          fi
        }

        handle() {
          case $1 in
            monitoradded*|monitorremoved*)
              echo "handling event: \"$1\""
              update ;;
          esac
        }

        echo "Starting service with instance \"$HYPRLAND_INSTANCE_SIGNATURE\""

        # Do initial configuration
        update

        socat -U - UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
      '';
    };
  };
}
