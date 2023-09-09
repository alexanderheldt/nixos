{ pkgs, ... }:
let
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable;
    config = ./config.org;
    defaultInitFile = pkgs.callPackage ./config.nix {};

    alwaysEnsure = true;
    alwaysTangle = true;
    #extraEmacsPackages = epkgs: with epkgs; [ use-package ];
  };
in
{
  home-manager.users.alex = {
    home.packages = [
      emacs
      pkgs.wl-clipboard
    ];
  };

  environment.systemPackages = [ pkgs.ripgrep ];
}
