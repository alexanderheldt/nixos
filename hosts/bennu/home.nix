{ pkgs, ... }:
{
  programs.home-manager.enable = true;

  home.username = "alex";
  home.homeDirectory = "/home/alex";

  home.packages = with pkgs; [
    vim
    emacs
    gnumake
    tig
    firefox-devedition-unwrapped
  ];

  programs.git = {
    enable = true;
    includes = [
      { path = ./configs/.gitconfig; }
    ];
  };

  home.stateVersion = "23.05";
}
