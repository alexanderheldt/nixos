{ pkgs, lib, config, ... }:
let
  enabled = config.mod.openvpn.enable;
in
{
  options = {
    mod.openvpn = {
      enable = lib.mkEnableOption "add openvpn related packages";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [
        pkgs.openvpn
        pkgs.update-systemd-resolved
      ];
    };

    services.resolved.enable = true;
  };
}
