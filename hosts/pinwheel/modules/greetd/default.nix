{ pkgs, lib, config, ... }:
let
  enabled = config.mod.greetd.enable;
in
{
  options = {
    mod.greetd = {
      enable = lib.mkEnableOption "enable greetd module";
    };
  };

  config = lib.mkIf enabled {
    services.greetd = {
      enable = true;

      settings = let
        session = {
          user = "alex";
          command = "${pkgs.hyprland}/bin/Hyprland";
        };
      in
        {
          initial_session = session;
          default_session = session;
      };
    };
  };
}
