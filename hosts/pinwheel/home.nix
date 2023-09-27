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
}
