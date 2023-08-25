{ home-manager, ... }:
{
  home-manager.users.alex = {
    programs.git = {
      enable = true;

      includes = [
        { path = ./gitconfig; }
      ];
    };
  };
}
