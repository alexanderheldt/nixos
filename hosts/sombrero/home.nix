{ inputs, ... }:
{

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.alex = {
        programs.home-manager.enable = true;

        home.username = "alex";
        home.homeDirectory = "/home/alex";

        home.packages = [];

        home.stateVersion = "22.11";
      };
    };
  };

}
