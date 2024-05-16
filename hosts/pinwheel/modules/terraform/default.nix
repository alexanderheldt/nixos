{ pkgs, ...}:
{
  home-manager.users.alex = {
    home.packages = [
      pkgs.terraform
      pkgs.terraform-ls
    ];
  };
}
