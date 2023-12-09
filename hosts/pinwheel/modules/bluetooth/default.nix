{ lib, config, ... }:
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
  };
}
