{ home-manager, pkgs, ... }:
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
      "github.com" = {
        hostname = "github.com";
        identityFile = "/home/alex/.ssh/alex.pinwheel-github.com";
      };
    };
  };

  age = {
    identityPaths = [
      "/etc/ssh/pinwheel"
      "/home/alex/.ssh/alex.pinwheel"
    ];
    
    secrets = {
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
    };
  }; 
}
