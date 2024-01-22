{ inputs, pkgs, ... }:
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

        home.packages = [
          pkgs.brogue-ce
          pkgs.jq
          pkgs.bitwarden
          pkgs.dbeaver
          pkgs.htop
          pkgs.onlyoffice-bin
          pkgs.wdisplays
          pkgs.ungoogled-chromium
          pkgs.unar
          pkgs.python3
        ];

        home.stateVersion = "23.05";
      };
    };
  };
}
