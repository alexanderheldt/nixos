{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;

  spotify-status = pkgs.writeShellScript "spotify-status" ''
    STATUS=$(${pkgs.playerctl}/bin/playerctl -p spotify status 2>&1)

    if [ "$STATUS" = "No players found" ]; then
      echo ""
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
           echo "Unknown status: $STATUS"
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
      STATUS=$(${pkgs.mullvad}/bin/mullvad status | awk 'NR==1{print $1}')
      echo $STATUS
    }

    output() {
      case $(status) in
        $STATUS_DISCONNECTED)
          echo '{ "text": "", "class": "disconnected" }' ;;
        $STATUS_CONNECTING)
          echo '{ "text": "", "tooltip": "Connecting", "class": "disconnected" }' ;;
        $STATUS_CONNECTED)
          TOOLTIP=$(${pkgs.mullvad}/bin/mullvad status | awk 'NR==1')
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
    STAGING=$(systemctl is-active openvpn-work-staging.service)
    [ "$STAGING" == "active" ] && echo "WORK-VPN STAGING ON" && exit 0

    PRODUCTION=$(systemctl is-active openvpn-work-production.service)
    [ "$PRODUCTION" == "active" ] && echo "WORK-VPN PRODUCTION ON" && exit 0
  '';

  toggle-bt-power = pkgs.writeShellScript "toggle-bt-power" ''
    POWERED_ON=$(bluetoothctl show | grep "Powered: yes")
    if [ -z "$POWERED_ON" ]; then
      bluetoothctl power on >> /dev/null
    else
      bluetoothctl power off >> /dev/null
    fi
  '';

  container-status = pkgs.writeShellScript "container-status" ''
    RUNNING=$(docker ps -q | wc -l)
    if [ "$RUNNING" -gt 0 ]; then
      echo "{ \"text\": \"\", \"tooltip\": \"containers running: $RUNNING\",  \"class\": \"running\" }"
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
            "custom/container-status"
            "custom/dunst"
            "custom/mullvad"
            "bluetooth"
            "wireplumber"
            "network"
            "battery"
            "clock"
          ];

          "custom/work-vpn-status" = {
            exec = "${work-vpn-status}";
            interval = 1;
          };

          "custom/spotify" = {
            exec = spotify-status;
            interval = 1;
            max-length = 70;
            tooltip = false;
          };

          "custom/container-status" = {
            exec = "${container-status}";
            return-type = "json";
            interval = 1;
          };

          "custom/dunst" = {
            exec = notifications-status;
            on-click-right = "${pkgs.dunst}/bin/dunstctl set-paused toggle";
            interval = 1;
            tooltip = false;
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
            interface = "wlan0";
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

      style = ''
        * {
          font-family: 'JetBrainsMono Nerd Font Mono';
          font-size: 22px;
        }

        #workspaces button {
          color: #${config.lib.colors.foreground-dim};
          background-color: #${config.lib.colors.background};
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
          color: #${config.lib.colors.foreground};
          background-color: #${config.lib.colors.background};
          }

        window#waybar {
          color: #${config.lib.colors.foreground};
          background-color: #${config.lib.colors.background};
        }

        #wireplumber.muted {
          color: #${config.lib.colors.warning};
        }

        #custom-mullvad.disconnected {
          color: #${config.lib.colors.warning};
        }

        #custom-work-vpn-status {
          color: #${config.lib.colors.warning};
        }

        #custom-container-status.running {
          color: #${config.lib.colors.warning};
          font-size: 30px;
        }

        #clock {
          margin-right: 10px;
        }
      '';
    };
  };
}
