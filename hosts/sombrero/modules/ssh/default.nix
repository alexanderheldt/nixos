{ lib, config, ... }:
let
  enabled = config.mod.ssh.enable;
in
{
  options = {
    mod.ssh = {
      enable = lib.mkEnableOption "enable ssh module";
    };
  };

  config = lib.mkIf enabled {
    services = {
      openssh = {
        enable = true;
        ports = [ 1122 ];
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 1122 ];
      };
    };
  };
}
