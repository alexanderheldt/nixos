{ lib, config, ... }:
let
  gitEnabled = config.mod.git.enable;
in
{
  home-manager.users.alex = {
    programs.vim = {
      enable = true;

      extraConfig = ''
        set noswapfile
      '';
    };

    programs.git = lib.mkIf gitEnabled {
      extraConfig = {
        core = {
          editor = "vim";
        };
      };
    };
  };
}
