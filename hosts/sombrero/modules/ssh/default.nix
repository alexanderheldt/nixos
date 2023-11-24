{ pkgs, lib, config, ... }:
let
  enabled = config.mod.ssh.enable;

  authorizedKeysPath = "/home/alex/.ssh/authorized-keys";
in
{
  options = {
    mod.ssh = {
      enable = lib.mkEnableOption "enable ssh module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      programs.ssh = {
        enable = true;

        matchBlocks = {
          "codeberg.org" = {
            hostname = "codeberg.org";
            identityFile = "/home/alex/.ssh/alex.sombrero-codeberg.org";
          };

          "github.com" = {
            hostname = "github.com";
            identityFile = "/home/alex/.ssh/alex.sombrero-github.com";
          };
        };
      };
    };

    environment.etc."ssh/authorized_keys_command" = {
      mode = "0755";
      text = ''
        #!${pkgs.bash}/bin/bash
        for file in ${authorizedKeysPath}/*; do
          ${pkgs.coreutils}/bin/cat "$file"
        done
      '';
    };

    services = {
      openssh = {
        enable = true;
        ports = [ 1122 ];

        hostKeys = [{
          path = "/etc/ssh/sombrero";
          type = "ed25519";
        }];

        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };

        authorizedKeysCommand = "/etc/ssh/authorized_keys_command";
        authorizedKeysCommandUser = "root";
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 1122 ];
      };
    };


    age.secrets = {
      "alex.pinwheel-sombrero.pub" = {
        file = ../../../../secrets/pinwheel/alex.pinwheel-sombrero.pub.age;
        path = "${authorizedKeysPath}/alex.pinwheel-sombrero.pub";
      };

      "alex.sombrereo-codeberg.org" = {
        file = ../../../../secrets/pinwheel/alex.sombrero-codeberg.org.age;
        path = "/home/alex/.ssh/alex.sombrero-codeberg.org";
        owner = "alex";
        group = "users";
      };
      "alex.pinwheel-codeberg.org.pub" = {
        file = ../../../../secrets/pinwheel/alex.sombrero-codeberg.org.pub.age;
        path = "/home/alex/.ssh/alex.sombrero-codeberg.org.pub";
        owner = "alex";
        group = "users";
      };

      "alex.sombrero-github.com" = {
        file = ../../../../secrets/sombrero/alex.sombrero-github.com.age;
        path = "/home/alex/.ssh/alex.sombrero-github.com";
        owner = "alex";
        group = "users";
      };
      "alex.sombrero-github.com.pub" = {
        file = ../../../../secrets/sombrero/alex.sombrero-github.com.pub.age;
        path = "/home/alex/.ssh/alex.sombrero-github.com.pub";
        owner = "alex";
        group = "users";
      };
    };
  };
}
