{ pkgs, lib, config, ... }:
let
  enabled = config.mod.restic.enable;
in
{
  options = {
    mod.restic = {
      enable = lib.mkEnableOption "enable restic module";
    };
  };

  config = lib.mkIf enabled {
    services = {
      restic.backups = {
        "sync" = {
          initialize = true;

          user = "alex";

          passwordFile = "/home/alex/backup/restic/password.file";
          environmentFile = "/home/alex/backup/restic/aws.env";
          repository = "s3:https://s3.eu-north-1.amazonaws.com/restic-sync-backup";

          paths = ["/home/alex/backup/sync"];

          timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
          };

          pruneOpts = [
            "--keep-daily 2"
            "--keep-weekly 7"
            "--keep-yearly 12"
          ];
        };
      };
    };

    environment.systemPackages = [ pkgs.restic ];
  };
}

