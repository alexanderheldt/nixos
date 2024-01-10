{ pkgs, lib, config, ... }:
let
  dockerEnabled = config.mod.containers.docker.enable;
  podmanEnabled = config.mod.containers.podman.enable;
in
{
  options = {
    mod.containers = {
      docker = {
        enable = lib.mkEnableOption "enable docker";
      };

      podman = {
        enable = lib.mkEnableOption "enable podman";
      };
    };
  };

  config = {
    virtualisation = {
      docker = lib.mkIf dockerEnabled {
        enable = true;
      };

      podman = lib.mkIf podmanEnabled {
        enable = true;
      };
    };

    users.users.alex.extraGroups = lib.mkIf dockerEnabled [ "docker" ];

    home-manager.users.alex = lib.mkIf dockerEnabled {
      home.packages = [ pkgs.docker-compose ];
    };
  };
}
