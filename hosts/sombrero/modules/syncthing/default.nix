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
            bennu.id = "YXA2PVY-XNUS5HZ-4ZC6A65-O3JRY3S-P6UKE6N-FSUBOYE-JZ7UJWR-ILXMUAW";
            pinwheel.id = "AKS5L2A-NFCG5GV-3U5SSSZ-PLOX6BQ-ZL5ALXI-D7OK4KE-R2JPWRJ-B6AQJQ7";
          };

          folders = {
            "hosts" = {
              path = "/home/alex/backup/sync/hosts";
              devices = [ "bennu" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "org" = {
              path = "/home/alex/backup/sync/org";
              devices = [ "phone" "bennu" "pinwheel" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "phone-gps" = {
              path = "/home/alex/backup/sync/gps";
              devices = [ "bennu" "phone" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "personal" = {
              path = "/home/alex/backup/sync/personal";
              devices = [ "bennu" "pinwheel" ];
              versioning = {
                type = "staggered";
                params = {
                  maxAge = "2592000"; # 30 days
                };
              };
            };

            "work" = {
              path = "/home/alex/backup/sync/work";
              devices = [ "bennu" "pinwheel" ];
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
              devices = [ "bennu" "pinwheel" ];
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
