{
  home-manager.users.alex.programs.ssh = {
    enable = true;

    matchBlocks = {
      "sombrero.local" = {
        hostname = "192.168.50.200";
        user = "alex";
        identityFile = "/home/alex/.ssh/alex.pinwheel-sombrero";
        port = 1122;
      };

      "sombrero.a2x.se" = {
        hostname = "sombrero.a2x.se";
        user = "alex";
        identityFile = "/home/alex/.ssh/alex.pinwheel-sombrero";
        port = 1122;
      };

      "github.com" = {
        hostname = "github.com";
        identityFile = "/home/alex/.ssh/alex.pinwheel-github.com";
      };

      "gitlab.com" = {
        hostname = "gitlab.com";
        identityFile = "/home/alex/.ssh/alex.pinwheel-work";
      };
    };
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
    "alex.pinwheel-work" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-work.age;
       path = "/home/alex/.ssh/alex.pinwheel-work";
       owner = "alex";
       group = "users";
    };
    "alex.pinwheel-work.pub" = {
       file = ../../../../secrets/pinwheel/alex.pinwheel-work.pub.age;
       path = "/home/alex/.ssh/alex.pinwheel-work.pub";
       owner = "alex";
       group = "users";
    };
  };

  services.openssh = {
    enable = true;

    hostKeys = [{
      path = "/etc/ssh/pinwheel";
      type = "ed25519";
    }];
  };
}
