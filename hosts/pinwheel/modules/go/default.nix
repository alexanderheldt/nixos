{ pkgs, ... }:
{
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
}
