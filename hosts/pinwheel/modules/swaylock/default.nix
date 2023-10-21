{ pkgs, lib, config, ... }:
let
  enabled = config.mod.swaylock.enable;
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  options = {
    mod.swaylock = {
      enable = lib.mkEnableOption "enable swaylock module";
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
          bind = [
            "$mod SHIFT, x, exec, ${pkgs.swaylock}/bin/swaylock -f && systemctl suspend"
            "$mod, x, exec, ${pkgs.playerctl}/bin/playerctl -p spotify pause; ${pkgs.swaylock}/bin/swaylock"
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
