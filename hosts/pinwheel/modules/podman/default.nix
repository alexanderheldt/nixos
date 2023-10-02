{ pkgs, lib, config, ... }:
let
  enabled = config.mod.podman.enable;
in
{
  options = {
    mod.podman = {
      enable = lib.mkEnableOption "enable podman module";
    };
  };

  config = lib.mkIf enabled {
    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings = {
          dns_enabled = true;
        };
      };
    };

    home-manager.users.alex = {
      home.packages = [ pkgs.podman-compose ];
    };
  };
}
