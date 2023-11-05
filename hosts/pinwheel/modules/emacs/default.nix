{ inputs, pkgs, ... }:
let
  emacs = pkgs.emacsWithPackagesFromUsePackage {
    package = pkgs.emacs-unstable;
    config = ./config.org;
    defaultInitFile = pkgs.callPackage ./config.nix {};

    alwaysEnsure = true;
    alwaysTangle = true;
    extraEmacsPackages = epkgs: [ epkgs.flymake-go-staticcheck ];
  };

  e = pkgs.writeShellScriptBin "e" ''
    ${emacs}/bin/emacs -nw
  '';

  ec = pkgs.writeShellScriptBin "ec" ''
    ${emacs}/bin/emacsclient -t -c -a=
  '';
in
{
  nixpkgs.overlays = [ inputs.emacs-overlay.overlay ];

  home-manager.users.alex = {
    home.sessionVariables = {
     EDITOR = "${e}/bin/e";
     VISUAL = "${e}/bin/e";
    };

    home.packages = [
      e
      ec
      emacs
      pkgs.wl-clipboard
    ];
  };

  environment.systemPackages = [ pkgs.ripgrep ];
}
