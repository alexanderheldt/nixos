{ pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [
      pkgs.nil
      pkgs.nix-tree
    ];
  };
}
