{ home-manager, pkgs, ...}:
{
  home-manager.users.alex = {
    programs.vim = {
      enable = true;

      extraConfig = ''
        set noswapfile
      '';
    };
  };
}