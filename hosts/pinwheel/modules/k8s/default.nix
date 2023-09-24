{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [
      pkgs.kubectl
      pkgs.kubernetes-helm
      pkgs.kind
    ];
  };
}
