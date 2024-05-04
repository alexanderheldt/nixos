{ pkgs, lib, config, ... }:
let
  gitEnabled = config.mod.git.enable;
  goEnabled = config.mod.go.enable;
  openvpnEnabled = config.mod.openvpn.enable;
in
{
  home-manager.users.alex = {
    home.sessionVariables = {
      GITHUB_ACTOR="Alexander Heldt";
      GITHUB_TOKEN="$(${pkgs.coreutils}/bin/cat ${config.age.secrets.work-github-token.path})";
    };

    programs.go = lib.mkIf goEnabled {
      goPrivate = [ "$(${pkgs.coreutils}/bin/cat ${config.age.secrets.work-go-private.path})" ];
    };

    programs.git = lib.mkIf gitEnabled {
      includes = [
        {
          path = config.age.secrets.work-gitconfig.path;
          condition = "gitdir:~/code/work/";
        }
      ];
    };

    programs.ssh = {
      enable = true;
    };
  };

  services.openvpn.servers = lib.mkIf openvpnEnabled {
    work-staging = {
      config = "config ${config.age.secrets.work-staging-ovpn.path}";
      autoStart = false;
    };

    work-production = {
      config = "config ${config.age.secrets.work-production-ovpn.path}";
      autoStart = false;
    };
  };

  age.secrets = {
    "work-gitconfig" = lib.mkIf gitEnabled {
      file = ../../../../secrets/pinwheel/work-gitconfig.age;
      path = "/home/alex/code/work/.work-gitconfig";
      owner = "alex";
      group = "users";
    };

    "work-github-token" = lib.mkIf gitEnabled {
      file = ../../../../secrets/pinwheel/work-github-token.age;
      path = "/home/alex/code/work/.work-github-token";
      owner = "alex";
      group = "users";
    };

    "work-go-private" = lib.mkIf goEnabled {
      file = ../../../../secrets/pinwheel/work-go-private.age;
      path = "/home/alex/code/work/.work-go-private";
      owner = "alex";
      group = "users";
    };

    "work-staging-ovpn" = lib.mkIf openvpnEnabled {
      file = ../../../../secrets/pinwheel/work-staging-ovpn.age;
    };

    "work-production-ovpn" = lib.mkIf openvpnEnabled {
      file = ../../../../secrets/pinwheel/work-production-ovpn.age;
    };
  };
}
