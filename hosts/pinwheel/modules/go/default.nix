{ home-manager, pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.gopls ];
  };

  environment.systemPackages = [ pkgs.go ];
}
