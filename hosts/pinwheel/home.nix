{ pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.alex = {
      programs.home-manager.enable = true;

      home.username = "alex";
      home.homeDirectory = "/home/alex";

      home.packages = with pkgs; [
        tig
        onlyoffice-bin
        qmk
      ];

      home.stateVersion = "23.05";
    };
  };

  age.secrets = {
    "netrc" = {
      file = ../../secrets/pinwheel/netrc.age;
      path = "/home/alex/.netrc";
      owner = "alex";
      group = "users";
    };
  };
}
