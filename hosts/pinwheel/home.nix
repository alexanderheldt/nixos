{ pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.alex = {
      programs.home-manager.enable = true;

      home.username = "alex";
      home.homeDirectory = "/home/alex";

      home.packages = [
        pkgs.tig
        pkgs.onlyoffice-bin
        pkgs.wdisplays
        pkgs.teams-for-linux
      ];

      home.stateVersion = "23.05";
    };
  };
}
