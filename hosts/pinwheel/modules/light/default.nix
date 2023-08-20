{ home-manager, pkgs, ... }:
{
  users.users.alex.extraGroups = [ "video" ];
  programs.light.enable = true;

  home-manager.users.alex = {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          ", XF86MonBrightnessUp, exec, ${pkgs.light}/bin/light -A 5"
          ", XF86MonBrightnessDown, exec, ${pkgs.light}/bin/light -U 5"       
        ];
      };
    };
  };
}
