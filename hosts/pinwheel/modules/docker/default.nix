{ pkgs, lib, config, ... }:
let
  enabled = config.mod.docker.enable;
in
{
  options = {
    mod.docker = {
      enable = lib.mkEnableOption "enable docker module";
    };
  };

  config = lib.mkIf enabled {
    virtualisation = {
      docker = {
        enable = true;
      };
    };

    users.users.alex.extraGroups = [ "docker" ];

    home-manager.users.alex = {
      home.packages = [ pkgs.docker-compose ];
    };
  };
}
