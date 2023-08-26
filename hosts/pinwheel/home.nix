{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  home.username = "alex";
  home.homeDirectory = "/home/alex";
 
  home.packages = with pkgs; [
    emacs
    gnumake
    tig
  ];

  services.dunst.enable = true;

  home.stateVersion = "23.05";
}
