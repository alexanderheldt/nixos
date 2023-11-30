{ lib, config, ... }:
let
  enabled = config.mod.power.enable;
in
{
  options = {
    mod.power = {
      enable = lib.mkEnableOption "enable power module";
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
    };
  };
}
