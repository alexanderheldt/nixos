{ pkgs, lib, config, ... }:
let
  enabled = config.mod.physlock.enable;
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  options = {
    mod.physlock = {
      enable = lib.mkEnableOption "enable physlock module";
    };
  };

  config = lib.mkIf enabled {
    services.physlock = {
      enable = true;

      # Wraps the `physlock` binary in a "wrapper" which allows any
      # user to run the wrapper (located in `config.security.wrapperDir`)
      allowAnyUser = true;

      lockOn = {
        hibernate = true;
        suspend = true;
      };
    };

    home-manager.users.alex = {
      wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
        settings = {
          bind =
            let
              pause-music = "${pkgs.playerctl}/bin/playerctl -p spotify pause";
            in
              [
                # will lock the screen with `physlock`, see `lockOn.suspend
                "$mod SHIFT, x, exec, ${pause-music}; systemctl suspend"
                "$mod, x, exec, ${pause-music}; ${config.security.wrapperDir}/physlock -d -s -m"
              ];
        };
      };
    };
  };
}
