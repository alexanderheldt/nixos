{ pkgs, lib, config, ... }:
let
  enabled = config.mod.containers.enable;
in
{
  options = {
    mod.containers = {
      enable = lib.mkEnableOption "enable containers module";
    };
  };

  config = lib.mkIf enabled {
    virtualisation = {
      docker = {
        enable = true;
      };

      podman = {
        enable = true;
      };
    };

    users.users.alex.extraGroups = [ "docker" ];

    home-manager.users.alex = {
      home.packages = [ pkgs.docker-compose ];
    };
  };
}
