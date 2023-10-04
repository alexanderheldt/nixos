{ pkgs, lib, config, ... }:
let
  enabled = config.mod.scripts.enable;

  t = pkgs.writeShellScriptBin "t" ''
    bash -c "$*"
    ${pkgs.libnotify}/bin/notify-send "CMD ended:" "$*"
  '';
in
{
  options = {
    mod.scripts = {
      enable = lib.mkEnableOption "add scripts module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [ t ];
    };
  };
}
