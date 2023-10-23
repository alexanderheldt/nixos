{ lib, config, ... }:
let
  enabled = config.mod.tlp.enable;
in
{
  options = {
    mod.tlp = {
      enable = lib.mkEnableOption "enable tlp module";
    };
  };

  config = lib.mkIf enabled {
    services = {
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
