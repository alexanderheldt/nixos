{ lib, config, ... }:
let
  gitEnabled = config.mod.git.enable;
  openvpnEnabled = config.mod.openvpn.enable;
in
{
  home-manager.users.alex = {
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

    "work-staging-ovpn" = lib.mkIf openvpnEnabled {
      file = ../../../../secrets/pinwheel/work-staging-ovpn.age;
    };

    "work-production-ovpn" = lib.mkIf openvpnEnabled {
      file = ../../../../secrets/pinwheel/work-production-ovpn.age;
    };
  };
}
