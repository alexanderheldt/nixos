{ pkgs, lib, config, ... }:
let
  enabled = config.mod.bluetooth.enable;
in
{
  options = {
    mod.bluetooth = {
      enable = lib.mkEnableOption "enable bluetooth module";
    };
  };

  config = lib.mkIf enabled {
    hardware.bluetooth = {
      enable = true;

      settings = {
        General = {
          Experimental = true;
        };
      };
    };

    services.blueman.enable = true;

    # Low battery notification for bluetooth devices
    systemd.user =
      let
        trackpad = {
          id = "battery_hid_a8o91o3doe5ofeo38_battery";
          name = "trackpad";
          threshold = "20";
        };

        headphones = {
          id = "headset_dev_38_18_4C_18_A4_6E";
          name = "headphones";
          threshold = "30";
        };
      in
        {
          timers =
            let
              mkTimer = device: {
                name = "notify-low-battery-for-${device.name}";

                value = {
                  unitConfig = {
                    Description = "notify-battery-low timer for '${device.name}'";
                  };

                  wantedBy = [ "timers.target" ];

                  timerConfig = {
                    Unit = "notify-low-battery-for-${device.name}.service";
                    OnCalendar = "*-*-* *:00:00"; # Every hour
                    Persistent = true;
                  };
                };
              };
            in
              builtins.listToAttrs (builtins.map mkTimer [ trackpad headphones ]);

          services =
            let
              mkService = device: {
                name = "notify-low-battery-for-${device.name}";

                value = {
                  unitConfig = {
                    Description = "check battery level of '${device.name}'";
                  };

                  wantedBy = [ "default.target" ];
                  serviceConfig = {
                    Type = "exec";
                  };

                  path = [
                    pkgs.upower
                    pkgs.gawk
                    pkgs.bc
                    pkgs.libnotify
                  ];

                  script = ''
                    CONNECTED=$(upower --show-info /org/freedesktop/UPower/devices/${device.id} | grep native-path | awk '{print $2}')
                    [ "$CONNECTED" == "(null)" ] && exit 0

                    CHECKING="/tmp/checking-dismiss-low-battery-${device.id}"
                    [ ! -f "$CHECKING" ] && touch $CHECKING || exit 0

                    DISMISSED="/tmp/dismiss-low-battery-${device.id}"
                    PERCENT=$(upower --show-info /org/freedesktop/UPower/devices/${device.id} | grep percentage | grep -o '[0-9]*')
                    if (( $(echo "$PERCENT < ${device.threshold}" | bc) )); then
                      echo "'${device.name}' is under threshold. battery = $PERCENT% - threshold = ${device.threshold}%"
                      if [ ! -f "$DISMISSED" ]; then
                        DISMISS=$(notify-send --expire-time 0 "Low battery" "${device.name} has $PERCENT% battery" --action=dismiss=Dismiss)
                        [ "$DISMISS" == "dismiss" ] && touch $DISMISSED && echo "'${device.name}' dismissed"
                      fi
                    else
                      echo "'${device.name}' is over threshold. battery = $PERCENT% - threshold = ${device.threshold}%"
                      [ -f "$DISMISSED" ] && rm $DISMISSED && echo "'${device.name}' undismissed"
                    fi

                    rm $CHECKING
                  '';
                };
              };
            in
              builtins.listToAttrs (builtins.map mkService [ trackpad headphones ]);
        };
  };
}
