{ ... }:
{
  home-manager.users.alex = {
    programs.git = {
      includes = [
        {
          path = ./work-gitconfig;
          condition = "gitdir:~/code/work/";
        }
      ];
    };

    programs.go = {
      goPrivate = [ "gitlab.com/zebware/*" ];
    };
  };

  age.secrets = {
    "netrc" = {
      file = ../../../../secrets/pinwheel/netrc.age;
      path = "/home/alex/.netrc";
      owner = "alex";
      group = "users";
    };
  };
}
