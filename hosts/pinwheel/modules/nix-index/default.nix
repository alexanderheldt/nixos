{ lib, config, ... }:
let
  enabled = config.mod.nix-index.enable;
in
{
  options = {
    mod.nix-index = {
      enable = lib.mkEnableOption "add nix-index module";
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      programs.nix-index = {
        enable = true;

        enableZshIntegration = true;
      };
    };
  };
}
