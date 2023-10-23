{ pkgs, lib, config, ... }:
let
  enabled = config.mod.openvpn.enable;
in
{
  options = {
    mod.openvpn = {
      enable = lib.mkEnableOption "enable openpn module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [
        pkgs.openvpn
        pkgs.update-systemd-resolved
      ];
    };

    services.resolved = {
      enable = false;
      dnssec = "true";
      domains = [ "~." ];
      fallbackDns = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      extraConfig = ''
        DNSOverTLS=yes
      '';
    };
  };
}
