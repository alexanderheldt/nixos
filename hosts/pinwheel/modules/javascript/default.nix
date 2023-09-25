{ pkgs, ...}:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.nodePackages.typescript-language-server ];
  };
}
