{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  home-manager.users.alex = {
    home.packages = [ pkgs.bemenu ];

    wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
      settings = {
        bind = [
          "$mod, SPACE, exec, ${pkgs.bemenu}/bin/bemenu-run --fn 'DejaVuSansM Nerd Font Mono 14'"
        ];
      };
    };
  };
}
