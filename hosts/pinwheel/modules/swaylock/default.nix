{ home-manager, pkgs, ... }:
{
  home-manager.users.alex = {
    programs.swaylock = {
      enable = true;

      settings = {
        color = "000000";
        indicator-idle-visible = false;
        show-failed-attempts = true;
      };
    };

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mod, x, exec, ${pkgs.swaylock}/bin/swaylock"
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
}
