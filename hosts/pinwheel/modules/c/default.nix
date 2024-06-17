{ pkgs, lib, config, ... }:
let
  enabled = config.mod.c.enable;
in
{
  options = {
    mod.c = {
      enable = lib.mkEnableOption "enable c module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [ pkgs.ccls ];
    };
  };
}
