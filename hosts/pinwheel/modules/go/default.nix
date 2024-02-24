{ pkgs, lib, config, ... }:
let
  enabled = config.mod.go.enable;
in
{
  options = {
    mod.go = {
      enable = lib.mkEnableOption "enable go module";
    };
  };

  config = lib.mkIf enabled {
    nixpkgs.overlays = let
      buildGo122 = pkgs: pkg:
        pkg.override { buildGoModule = pkgs.buildGo122Module; };
    in
    [
      (final: prev: {
        go = prev.go_1_22;
        gopls = buildGo122 prev prev.gopls;
        go-tools = buildGo122 prev prev.go-tools;
        govulncheck = buildGo122 prev prev.govulncheck;
        gotestsum = buildGo122 prev prev.gotestsum;
      })
    ];

    home-manager.users.alex = {
      programs.go = {
        enable = true;

        package = pkgs.go;
        goPath = "code/go";
      };

      home.packages = [
        pkgs.gopls
        pkgs.go-tools
        pkgs.govulncheck
        pkgs.go-licenses
        pkgs.gotestsum
      ];

      programs.zsh = {
        envExtra = ''
          PATH=$PATH:/home/alex/code/go/bin
        '';
      };
    };
  };
}
