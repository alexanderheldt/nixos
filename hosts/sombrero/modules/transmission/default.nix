{ pkgs, lib, config, ... }:
let
  enabled = config.mod.transmission.enable;
in
{
  options = {
    mod.transmission = {
      enable = lib.mkEnableOption "enable transmission module";
    };
  };

  config = lib.mkIf enabled {
    services = {
      transmission = {
        enable = true;
        openFirewall = true;
        openRPCPort = true;
        settings.rpc-port = 9191;
        settings.rpc-bind-address = "0.0.0.0";

        user = "alex";
        group = "users";

        home = "/home/alex/media/ts-home";
        downloadDirPermissions = "775";

        settings = {
          incomplete-dir-enabled = false;
          download-dir = "/home/alex/media";

          rpc-authentication-required = true;
          rpc-whitelist-enabled = false;
          rpc-username = "transmission";
          rpc-password = "{55d884e4042db67313da49e05d7089a368eb64b3Br.3X.Xi";
        };
      };
    };

    environment.systemPackages = [ pkgs.transmission ];
  };
}
