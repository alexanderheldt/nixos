{ pkgs, ... }:
{
  home-manager.users.alex = {
    programs.ssh = {
      enable = true;

      matchBlocks = {
        "sombrero.local" = {
          hostname = "192.168.50.200";
          user = "alex";
          identityFile = "/home/alex/.ssh/alex.pinwheel-sombrero";
          port = 1122;
        };

        "sombrero" = {
          hostname = "sombrero.a2x.se";
          user = "alex";
          identityFile = "/home/alex/.ssh/alex.pinwheel-sombrero";
          port = 1122;
        };

        "andromeda" = {
          hostname = "andromeda.a2x.se";
          user = "alex";
          identityFile = "/home/alex/.ssh/alex.pinwheel-andromeda";
        };

        "github.com" = {
          hostname = "github.com";
          identityFile = "/home/alex/.ssh/alex.pinwheel-github.com";
        };

        "codeberg.org" = {
          hostname = "codeberg.org";
          identityFile = "/home/alex/.ssh/alex.pinwheel-codeberg.org";
        };
      };
    };

    home.packages = [ pkgs.sshfs ];
  };

  age.secrets = {
    "alex.pinwheel-sombrero" = {
      file = ../../../../secrets/pinwheel/alex.pinwheel-sombrero.age;
      path = "/home/alex/.ssh/alex.pinwheel-sombrero";
      owner = "alex";
      group = "users";
    };
    "alex.pinwheel-sombrero.pub" = {
      file = ../../../../secrets/pinwheel/alex.pinwheel-sombrero.pub.age;
      path = "/home/alex/.ssh/alex.pinwheel-sombrero.pub";
      owner = "alex";
      group = "users";
    };

    "alex.pinwheel-github.com" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-github.com.age;
       path = "/home/alex/.ssh/alex.pinwheel-github.com";
       owner = "alex";
       group = "users";
    };
    "alex.pinwheel-github.com.pub" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-github.com.pub.age;
       path = "/home/alex/.ssh/alex.pinwheel-github.com.pub";
       owner = "alex";
       group = "users";
    };

    "alex.pinwheel-codeberg.org" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-codeberg.org.age;
       path = "/home/alex/.ssh/alex.pinwheel-codeberg.org";
       owner = "alex";
       group = "users";
    };
    "alex.pinwheel-codeberg.org.pub" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-codeberg.org.pub.age;
       path = "/home/alex/.ssh/alex.pinwheel-codeberg.org.pub";
       owner = "alex";
       group = "users";
    };

    "alex.pinwheel-andromeda" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-andromeda.age;
       path = "/home/alex/.ssh/alex.pinwheel-andromeda";
       owner = "alex";
       group = "users";
    };
    "alex.pinwheel-andromeda.pub" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-andromeda.pub.age;
       path = "/home/alex/.ssh/alex.pinwheel-andromeda.pub";
       owner = "alex";
       group = "users";
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 1122 ];

    hostKeys = [{
      path = "/etc/ssh/pinwheel";
      type = "ed25519";
    }];
  };
}
