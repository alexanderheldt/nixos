{ lib, config, ... }:
let
  enable = config.mod.plex.enable;
  dockerEnabled = config.mod.docker.enable;
in
{
  options = {
    mod.plex = {
      enable = lib.mkEnableOption "enable plex module";
    };
  };

  config = lib.mkIf (enable && dockerEnabled) {
    virtualisation = {
      oci-containers.containers = {
        plex = {
          image = "linuxserver/plex";
          autoStart = true;

          environment = {
            TZ = "Europe/Stockholm";
            VERSION = "latest";
          };

          extraOptions = [ "--network=host" ];

          volumes = [
            "/home/alex/media/plex/db:/config"
            "/home/alex/media/Movies:/movies"
            "/home/alex/media/TV:/tv"
          ];
        };
      };
    };

    networking = {
      firewall = {
        allowedTCPPorts = [ 32400 ];
      };
    };
  };
}
