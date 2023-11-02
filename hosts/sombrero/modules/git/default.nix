{ pkgs, lib, config, ... }:
let
  enabled = config.mod.git.enable;
in
{
  options = {
    mod.git = {
      enable = lib.mkEnableOption "enable git module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      programs.git = {
        enable = true;

        includes = [
          { path = ./gitconfig; }
        ];
      };
    };
  };
}
