{ lib, config, ... }:
let
  enabled = config.mod.calibre-web.enable;
  nginxEnabled = config.mod.nginx.enable;
in
{
  options = {
    mod.calibre-web = {
      enable = lib.mkEnableOption "add calibre-web module";
    };
  };

  config = lib.mkIf (enabled && nginxEnabled) {
    services = {
      calibre-web = {
        enable = true;

        user = "alex";
        group = "users";

        listen = {
          ip = "127.0.0.1";
          port = 8083;
        };

        options = {
          calibreLibrary = "/home/alex/backup/books";
          enableBookUploading = true;
        };
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 8083 ];
      };
    };

    services = {
      nginx = {
        virtualHosts."books.sombrero.a2x.se" = {
          forceSSL = true;
          enableACME = true;

          locations."/" = {
            proxyPass = "http://127.0.0.1:8083";
          };
        };
      };
    };
  };
}
