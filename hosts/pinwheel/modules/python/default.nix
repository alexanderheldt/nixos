{ pkgs, lib, config, ... }:
let
  enabled = config.mod.python.enable;
in
{
  options = {
    mod.python = {
      enable = lib.mkEnableOption "enable python module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      home.packages = [
        pkgs.python3
        pkgs.python312Packages.python-lsp-server
      ];
    };
  };
}
