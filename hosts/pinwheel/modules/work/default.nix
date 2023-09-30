{ pkgs, lib, config, ... }:
let
  openvpnEnabled = config.mod.openvpn.enable;

  work-vpn = let
    ovpnconfig = config.age.secrets.work-ovpn.path;
    userpass = config.age.secrets.work-ovpn-userpass.path;
  in
    pkgs.writeShellApplication {
    name = "work-vpn";
    text = ''
        sudo \
        ${pkgs.openvpn}/bin/openvpn \
        --script-security 2 \
        --up ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved \
        --up-restart \
        --down ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved \
        --down-pre \
        --config ${ovpnconfig} \
        --auth-user-pass ${userpass}
    '';
  };
in
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
