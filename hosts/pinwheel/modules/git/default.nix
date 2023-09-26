{ ... }:
{
  home-manager.users.alex = {
    programs.git = {
      enable = true;

      includes = [
        { path = ./gitconfig; }
        {
          path = ./work-gitconfig;
          condition = "gitdir:~/code/work/";
        }
      ];
    };
  };
}
