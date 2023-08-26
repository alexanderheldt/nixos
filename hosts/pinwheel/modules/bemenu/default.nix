{ home-manager, pkgs, ... }:
{
  home-manager.users.alex = {
    home.packages = [ pkgs.bemenu ];

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mod, SPACE, exec, ${pkgs.bemenu}/bin/bemenu-run --fn 'DejaVuSansM Nerd Font Mono 14'"
        ];
      };
    };
  };
}
