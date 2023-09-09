{ pkgs, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.alex = {
      programs.home-manager.enable = true;

      home.username = "alex";
      home.homeDirectory = "/home/alex";

      services.dunst.enable = true;

      home.packages = with pkgs; [
        gnumake
        tig
        spotify
        onlyoffice-bin
        qmk
      ];

      home.stateVersion = "23.05";
    };
  };
}
