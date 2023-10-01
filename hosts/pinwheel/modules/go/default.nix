{ pkgs, lib, config, ... }:
let
  enabled = config.mod.go.enable;
in
{
  options = {
    mod.go = {
      enable = lib.mkEnableOption "enable openpn module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      programs.go = {
        enable = true;

        package = pkgs.go_1_21;
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
