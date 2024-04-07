{ pkgs, lib, config, ... }:
let
  enabled = config.mod.scala.enable;
in
{
  options = {
    mod.scala = {
      enable = lib.mkEnableOption "enable scala module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [
        pkgs.metals
      ];
    };
  };
}
