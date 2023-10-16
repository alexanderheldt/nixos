{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;

  spotify-status = pkgs.writeShellScript "spotify-status" ''
    STATUS=$(${pkgs.playerctl}/bin/playerctl -p spotify status 2>&1)

    if [ "$STATUS" = "No players found" ]; then
      echo " "
    else
      FORMAT="{{markup_escape(xesam:title)}} - {{markup_escape(xesam:artist)}}"
      OUTPUT=$(${pkgs.playerctl}/bin/playerctl -p spotify metadata --format "$FORMAT")
      case "$STATUS" in
        "Playing")
          echo "<span font='14' rise='-3000'></span> $OUTPUT"
          ;;
         "Paused")
           echo "<span font='14' rise='-3000'></span> $OUTPUT"
           ;;
         *)
           echo " "
           ;;
      esac
    fi
  '';

  notifications-status = pkgs.writeShellScript "notifications-status" ''
    if ${pkgs.dunst}/bin/dunstctl is-paused | grep -q "false"; then
      echo "<span font='14'></span>"
    else
      DISABLED=
      COUNT=$(${pkgs.dunst}/bin/dunstctl count waiting)
      [ $COUNT != 0 ] && DISABLED="<span font='11' rise='1000'> $COUNT</span>"
      echo "<span font='14'>$DISABLED</span>"
    fi
  '';

  mullvad = pkgs.writeShellScript "mullvad" ''
    STATUS_DISCONNECTING="Disconnecting"
    STATUS_DISCONNECTED="Disconnected"
    STATUS_CONNECTING="Connecting"
    STATUS_CONNECTED="Connected"

    status() {
      STATUS=$(${pkgs.mullvad}/bin/mullvad status | awk '{print $1}')
      echo $STATUS
    }

    output() {
      case $(status) in
        $STATUS_DISCONNECTED)
          echo '{ "text": "", "class": "disconnected" }' ;;
        $STATUS_CONNECTING)
          echo '{ "text": "", "tooltip": "Connecting", "class": "disconnected" }' ;;
        $STATUS_CONNECTED)
          TOOLTIP=$(${pkgs.mullvad}/bin/mullvad status)
          echo "{ \"text\": \"\", \"tooltip\":\"$TOOLTIP\" }" ;;
        $STATUS_DISCONNECTING)
          echo '{ "text": "", "tooltip": "Disconnecting", "class": "disconnected" }' ;;
        *)
          echo '{ "text": "", "tooltip": "Status unknown", "class": "disconnected" }' ;;
        esac
    }

    toggle() {
      CURRENT_STATUS=$(status)

      case "$CURRENT_STATUS" in
        $STATUS_DISCONNECTED)
          ${pkgs.mullvad}/bin/mullvad connect --wait > /dev/null && notify-send "Connected to VPN";;
        $STATUS_CONNECTED)
          ${pkgs.mullvad}/bin/mullvad disconnect --wait > /dev/null && notify-send "Disconnected from VPN";;
      esac
    }

    case $1 in
      --toggle)
          toggle ;;
      --output)
          output ;;
    esac
  '';

  work-vpn-status = pkgs.writeShellScript "work-vpn-status" ''
    ON=$(ls /tmp | grep work-vpn-on | wc -l)
    [ "$ON" -gt 0 ] && echo "WORK-VPN ON"
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
        internal = {
          name = "internal";
          layer = "top";
          position = "top";
          height = 30;
          spacing = 20;
          fixed-center = false;
          output = [ "eDP-1" ];

          modules-left = lib.mkIf hyprlandEnabled [ "hyprland/workspaces" ];
          modules-right = [
            "custom/work-vpn-status"
            "custom/spotify"
            "custom/dunst"
            "custom/mullvad"
            "bluetooth"
            "wireplumber"
            "network"
            "battery"
            "clock"
          ];

          "custom/spotify" = {
            exec = spotify-status;
            interval = 1;
            max-length = 70;
            tooltip = false;
          };

          "custom/dunst" = {
            exec = notifications-status;
            on-click-right = "${pkgs.dunst}/bin/dunstctl set-paused toggle";
            interval = 1;
            tooltip = false;
          };

          "custom/work-vpn-status" = {
            exec = "${work-vpn-status}";
            interval = 1;
          };

          "custom/mullvad" = {
            exec = "${mullvad} --output";
            return-type = "json";
            on-click-right = "${mullvad} --toggle";
            interval = 1;
          };

          bluetooth = {
            "format-off" = "󰂲";
            "format-on" = "";
            "format-connected" = "";
            "on-click" = "${pkgs.blueman}/bin/blueman-manager";
            "on-click-right" = toggle-bt-power;
          };

          wireplumber = {
            format = "<span font='16' rise='-3000'></span> {volume}%";
            format-muted = "<span font='16' rise='-3000'></span> {volume}%";
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
            on-click-right = "${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            max-volume = 150;
            scroll-step = 0.2;
          };

          network = {
            interface = "wlp0s20f3";
            format-wifi = "<span font='16' rise='-3000'>󰖩</span>";
            format-disconnected = "<span font='16' rise='-3000'>󱚵</span>";
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
          };

          battery = {
            "interval" = 60;
            "format" = "<span font='10' rise='1000'>{icon}</span> {capacity}%";
            "format-time" = "{H}h {M}min";
            "format-charging" ="󰂄 {capacity}%";
            "format-icons" = ["󰁺" "󰁻" "󰁽" "󰁿" "󰂁" "󰁹" ];
          };

          "clock" = {
            "interval" = 1;
            "format" = "{:%H:%M:%S}";
            "format-alt" = "{:%a, %B %d %H:%M:%S}";
          };
        };

        external = {
          name = "external";
          layer = "top";
          position = "top";
          height = 30;
          spacing = 20;
          fixed-center = false;
          output = [ "HDMI-A-1" ];

          modules-left = lib.mkIf hyprlandEnabled [ "hyprland/workspaces" ];
          modules-right = [
            "custom/work-vpn-status"
            "clock"
          ];

          "custom/work-vpn-status" = {
            exec = "${work-vpn-status}";
            interval = 1;
          };

          "clock" = {
            "interval" = 1;
            "format" = "{:%H:%M:%S}";
            "format-alt" = "{:%a, %B %d %H:%M:%S}";
          };
        };
      };

      style = let
        foreground = "#f9c22b";
        foreground-dim = "#a57b06";
        background = "#262626";
        warning = "#FF6969";
      in
        ''
        * {
          font-family: 'DejaVuSansM Nerd Font Mono';
          font-size: 22px;
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

        #wireplumber.muted {
          color: ${warning};
        }

        #custom-mullvad.disconnected {
          color: ${warning};
        }

        #custom-work-vpn-status {
          color: ${warning};
        }

        #clock {
          margin-right: 10px;
        }
      '';
    };
  };
}
