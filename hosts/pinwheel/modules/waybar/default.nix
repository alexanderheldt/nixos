{ pkgs, ... }:
let
  spotify-status = pkgs.writeShellScript "spotify-status" ''
    STATUS=$(${pkgs.playerctl}/bin/playerctl -p spotify status 2>&1)

    if [ "$STATUS" = "No players found" ]; then
      echo " "
    else
      TITLE=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata xesam:title)
      ARTIST=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata xesam:artist)

      case "$STATUS" in
        "Playing")
          echo "<span font='14' rise='-3000'></span> $TITLE - $ARTIST"
          ;;
         "Paused")
           echo "<span font='14' rise='-3000'></span> $TITLE - $ARTIST"
           ;;
         *)
           echo " "
	   ;;
      esac
    fi
  '';

  toggle-bt-power = pkgs.writeShellScript "toggle-bt-power" ''
    POWERED_ON=$(bluetoothctl show | grep "Powered: yes")
    if [ -z "$POWERED_ON" ]; then
      bluetoothctl power on >> /dev/null
    else
      bluetoothctl power off >> /dev/null
    fi
  '';
in
{
  home-manager.users.alex = {
    programs.waybar = {
      enable = true;

      settings = {
        bar1 = {
          name = "bar1";
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "eDP-1"
            "HDMI-A-1"
          ];

          modules-left = [ "hyprland/workspaces" ];
          modules-right = [ "custom/spotify" "bluetooth" "wireplumber" "battery" "clock" ];

          "custom/spotify" = {
            exec = spotify-status;
            interval = 1;
            tooltip = false;
          };

          bluetooth = {
            "format-off" = "󰂲";
            "format-on" = "";
            "format-connected" = "";
            "on-click" = "${pkgs.blueman}/bin/blueman-manager";
            "on-click-right" = toggle-bt-power;
          };

          wireplumber = {
            format = "{volume}%";
            format-muted = "";
            on-click = "pavucontrol";
            max-volume = 150;
            scroll-step = 0.2;
          };
        };
      };

      style = let
        foreground = "#f9c22b";
        foreground-dim = "#a57b06";
        background = "#262626";
      in
        ''
        * {
          font-family: 'DejaVuSansM Nerd Font Mono';
          font-size: 20px;
        }

        #workspaces button {
          color: ${foreground-dim};
          background-color: ${background};
          border: none;
        }

        #workspaces button:hover {
          border-color: transparent;
          background: none;
          transition: none;
          text-shadow: none;
          box-shadow: none;
        }

        #workspaces button.active {
          color: ${foreground};
          background-color: ${background};
        }

        window#waybar {
          color: ${foreground};
          background-color: ${background};
        }

        #custom-spotify, #bluetooth, #wireplumber, #battery, #clock {
          margin: 0 12px;
        }
      '';
    };
  };
}
