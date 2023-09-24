{ pkgs, ... }:
{
  home-manager.users.alex = {
    programs.go = {
      enable = true;

      package = pkgs.go_1_21;
      goPath = "code/go";
    };

    home.packages = [ pkgs.gopls ];

    programs.zsh = {
      envExtra = ''
        PATH=$PATH:/home/alex/code/go/bin
      '';
    };
  };
}
