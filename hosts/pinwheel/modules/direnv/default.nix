{ lib, config, ... }:
let
  zshEnabled = config.mod.zsh.enable;
in
{
  home-manager.users.alex = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };


    programs.direnv.enableZshIntegration = lib.mkIf zshEnabled true;
  };
}
