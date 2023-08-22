{ home-manager, pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.calibre ];
  };

  # Needed to access mounted e-readers
  services.udisks2.enable = true; 
}
