{ lib, config, ... }:
let
  enabled = config.mod.nginx.enable;
in
{
  options = {
    mod.nginx = {
      enable = lib.mkEnableOption "add nginx module";
    };
  };

  config = lib.mkIf enabled {
    security = {
      acme = {
        acceptTerms = true;

        defaults = {
          email = "alex@a2x.se";
        };
      };
    };

    services = {
      nginx = {
        enable = true;

        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 80 443 ];
      };
    };
  };
}
