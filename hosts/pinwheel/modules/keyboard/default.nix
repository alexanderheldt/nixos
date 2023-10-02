{ pkgs, lib, config, ... }:
let
  enabled = config.mod.keyboard.enable;
in
{
  options = {
    mod.keyboard = {
      enable = lib.mkEnableOption "add keyboard module";
    };
  };

  config = lib.mkIf enabled {
    console.keyMap = "sv-latin1";

    hardware.keyboard.qmk.enable = true;
    hardware.keyboard.zsa.enable = true;

    home-manager.users.alex = {
      home.packages = [
        pkgs.qmk
        pkgs.wally-cli
      ];
    };
  };
}
