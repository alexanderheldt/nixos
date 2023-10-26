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
      buildGo121 = pkgs: pkg:
        pkg.override { buildGoModule = pkgs.buildGo121Module; };
    in
    [
      (final: prev: {
        go = prev.go_1_21;
        gopls = buildGo121 prev prev.gopls;
        go-tools = buildGo121 prev prev.go-tools;
        govulncheck = buildGo121 prev prev.govulncheck;
        gotestsum = buildGo121 prev prev.gotestsum;
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
