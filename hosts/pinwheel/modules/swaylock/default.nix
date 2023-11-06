{ pkgs, lib, config, ... }:
let
  enabled = config.mod.swaylock.enable;
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  options = {
    mod.swaylock = {
      enable = lib.mkEnableOption "enable swaylock module";

      dpmsTimeout = lib.mkOption {
        description = "timeout in seconds before DPMS is turned on";
        type = lib.types.str;
        default = "10";
      };
    };
  };

  config = lib.mkIf enabled {
    home-manager.users.alex = {
      programs.swaylock = {
        enable = true;

        settings = {
          color = "000000";
          indicator-idle-visible = false;
          show-failed-attempts = true;
        };
      };

      wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
        settings = {
          bind = let
            pause-music = "${pkgs.playerctl}/bin/playerctl -p spotify pause";

            dpmsTimeout = config.mod.swaylock.dpmsTimeout;
            dpms-lock = pkgs.writeShellScript "dpms-lock" ''
              ${pkgs.swayidle}/bin/swayidle \
                timeout ${dpmsTimeout} "${pkgs.hyprland}/bin/hyprctl dispatch dpms off" \
                resume "${pkgs.hyprland}/bin/hyprctl dispatch dpms on" &

              ${pkgs.swaylock}/bin/swaylock && pkill swayidle
            '';
          in
            [
              "$mod, x, exec, ${pause-music}; ${dpms-lock}"
              "$mod SHIFT, x, exec, ${pause-music}; ${pkgs.swaylock}/bin/swaylock -f; systemctl suspend"
            ];
        };
      };
    };

    security = {
      polkit.enable = true;

      pam.services.swaylock.text = ''
        # PAM configuration file for the swaylock screen locker. By default, it includes
        # the 'login' configuration file (see /etc/pam.d/login)
        auth include login
      '';
    };
  };
}
