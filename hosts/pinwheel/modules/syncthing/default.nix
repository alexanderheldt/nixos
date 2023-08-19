{ config, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
 
    cert = config.age.secrets.syncthing-cert.path;
    key = config.age.secrets.syncthing-key.path;

    user = "alex";
    group = "users";

    dataDir = "/home/alex/sync";
 
    settings = {
      devices = {
        sombrero.id = "DIKHOMV-QGZV3DR-FXQZH45-I5J5R4R-JJZS5BA-XNNW5C7-QSSU3XV-KVC4MAQ";
        phone.id = "NJIMX57-C2CGV76-GXMAQYV-ABWDA7Z-TS6UV2X-NVL5UPG-UFEQH4C-TKYA6QM";
      };
 
      folders = {
        org = {
          path = "/home/alex/sync/org";
          devices = [ "sombrero" "phone" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        personal = {
          path = "/home/alex/sync/personal";
          devices = [ "sombrero" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        work = {
          path = "/home/alex/sync/work";
          devices = [ "sombrero" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "phone-gps" = {
          path = "/home/alex/sync/phone-gps";
          devices = [ "phone" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "time-tracking" = {
          path = "/home/alex/sync/time-tracking";
          devices = [ "phone" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };
      };
    };
  };

  age = {
    secrets = {
      "syncthing-cert".file = ../../../../secrets/pinwheel/syncthing-cert.age;
      "syncthing-key".file = ../../../../secrets/pinwheel/syncthing-key.age;
    };
  };
}
