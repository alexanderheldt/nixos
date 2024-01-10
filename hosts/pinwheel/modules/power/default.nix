{ pkgs, lib, config, ... }:
let
  enabled = config.mod.power.enable;

  notifyBatteryCapacity = config.mod.power.notifyBatteryCapacity;
in
{
  options = {
    mod.power = {
      enable = lib.mkEnableOption "enable power module";

      notifyBatteryCapacity = lib.mkOption {
        default = "5";
        description = "Battery level when warning notification is sent";
      };
    };
  };

  config = lib.mkIf enabled {
    services = {
      upower = {
        enable = true;
      };

      tlp = {
        enable = true;

        settings = {
          START_CHARGE_THRESH_BAT0=75;
          STOP_CHARGE_THRESH_BAT0=80;
        };
      };

      udev = {
        path = [ pkgs.libnotify ];

        extraRules = ''
          SUBSYSTEM=="power_supply", ATTR{status}=="Discharging", RUN+="${pkgs.libnotify}/bin/notify-send test"
        '';
      };

    };
  };
}
