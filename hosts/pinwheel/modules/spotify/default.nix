{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.spotify ];
  };
}
