{ lib, config, ... }:
let
  enabled = config.mod.syncthing.enable;
  nginxEnabled = config.mod.nginx.enable;
in
{
  options = {
    mod.syncthing = {
      enable = lib.mkEnableOption "add syncthing module";
    };
  };

  config = lib.mkIf (enabled && nginxEnabled) {
    networking = {
      firewall = {
        allowedTCPPorts = [ 8384 ];
      };
    };

    services = {
      syncthing = {
        enable = true;
        openDefaultPorts = true;

        user = "alex";
        group = "users";

        dataDir = "/home/alex/backup/sync";

        cert = config.age.secrets.syncthing-cert.path;
        key = config.age.secrets.syncthing-key.path;

        guiAddress = "0.0.0.0:8384";

        settings = {
          extraOptions = {
            gui = {
              user = "syncthing";
              password = "CBLPEBrHoGPOnfdZtLibnSAaPAALXfSU";
              insecureSkipHostcheck = false;
            };
          };

          devices = {
            phone.id = "NJIMX57-C2CGV76-GXMAQYV-ABWDA7Z-TS6UV2X-NVL5UPG-UFEQH4C-TKYA6QM";
            pinwheel.id = "AKS5L2A-NFCG5GV-3U5SSSZ-PLOX6BQ-ZL5ALXI-D7OK4KE-R2JPWRJ-B6AQJQ7";
          };

          folders = {
            "org" = {
              path = "/home/alex/backup/sync/org";
              devices = [ "phone" "pinwheel" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "phone-gps" = {
              path = "/home/alex/backup/sync/gps";
              devices = [ "phone" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "personal" = {
              path = "/home/alex/backup/sync/personal";
              devices = [ "pinwheel" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "work" = {
              path = "/home/alex/backup/sync/work";
              devices = [ "pinwheel" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "time-tracking" = {
              path = "/home/alex/backup/sync/time-tracking";
              devices = [ "phone" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "books" = {
              path = "/home/alex/backup/books";
              devices = [ "pinwheel" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "audiobooks" = {
              path = "/home/alex/media/sync/audiobooks";
              devices = [ "phone" ];
            };
          };
        };
      };

      nginx = {
        virtualHosts."syncthing.sombrero.a2x.se" = {
          forceSSL = true;
          enableACME = true;

          locations."/" = {
            proxyPass = "http://0.0.0.0:8384";
          };
        };
      };
    };

    age = {
      secrets = {
        "syncthing-cert".file = ../../../../secrets/sombrero/syncthing-cert.age;
        "syncthing-key".file = ../../../../secrets/sombrero/syncthing-key.age;
      };
  };
  };
}
