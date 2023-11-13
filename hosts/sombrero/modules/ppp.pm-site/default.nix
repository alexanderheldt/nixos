{ lib, config, ... }:
let
  enabled = config.mod.pppdotpm-site.enable;

  nginxEnabled = config.mod.nginx.enable;
in
{
  options = {
    mod.pppdotpm-site = {
      enable = lib.mkEnableOption "enable ppp.pm site";
    };
  };

  config = lib.mkIf (enabled && nginxEnabled) {
    security.acme = {
      certs = {
        "ppp.pm" = {
          webroot = "/var/lib/acme/acme-challenge/";
          email = "p@ppp.pm";
          group = "nginx";
        };
      };
    };

    services.pppdotpm-site = {
      enable = true;
      domain = "ppp.pm";
      useACMEHost = "ppp.pm";
    };
  };
}
