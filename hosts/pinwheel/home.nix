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
          pkgs.zip
          pkgs.brogue-ce
          pkgs.jq
          pkgs.bitwarden
          pkgs.dbeaver-bin
          pkgs.htop
          pkgs.onlyoffice-bin
          pkgs.wdisplays
          pkgs.ungoogled-chromium
          pkgs.unar
        ];

        home.stateVersion = "23.05";
      };
    };
  };
}
