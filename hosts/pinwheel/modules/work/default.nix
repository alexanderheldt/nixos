{ pkgs, lib, config, ... }:
let
  gitEnabled = config.mod.git.enable;
  goEnabled = config.mod.go.enable;
  openvpnEnabled = config.mod.openvpn.enable;

  work-vpn = let
    ovpnconfig = config.age.secrets.work-ovpn.path;
    userpass = config.age.secrets.work-ovpn-userpass.path;
  in
    pkgs.writeShellApplication {
    name = "work-vpn";
    text = ''
        touch /tmp/work-vpn-on; \
        sudo \
        ${pkgs.openvpn}/bin/openvpn \
        --script-security 2 \
        --up ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved \
        --up-restart \
        --down ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved \
        --down-pre \
        --config ${ovpnconfig} \
        --auth-user-pass ${userpass}; \
        rm /tmp/work-vpn-on
    '';
  };
in
{
  home-manager.users.alex = {
    programs.git = lib.mkIf gitEnabled {
      includes = [
        {
          path = ./work-gitconfig;
          condition = "gitdir:~/code/work/";
        }
      ];
    };

    programs.go = lib.mkIf goEnabled {
      goPrivate = [ "gitlab.com/zebware/*" ];
    };

    home.packages = lib.mkIf openvpnEnabled [ work-vpn ];
  };

  age.secrets = {
    "netrc" = {
      file = ../../../../secrets/pinwheel/netrc.age;
      path = "/home/alex/.netrc";
      owner = "alex";
      group = "users";
    };

    "work-ovpn" = lib.mkIf openvpnEnabled {
      file = ../../../../secrets/pinwheel/work-ovpn.age;
    };

    "work-ovpn-userpass" = lib.mkIf openvpnEnabled {
      file = ../../../../secrets/pinwheel/work-ovpn-userpass.age;
    };
  };
}
