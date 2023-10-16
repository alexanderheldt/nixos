{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  home-manager.users.alex = {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          term = "xterm-256color";
          font = "DejaVuSansM Nerd Font Mono:size=14";
        };
      };
    };

    wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
      settings = {
        bind = [
          "$mod, RETURN, exec, ${pkgs.foot}/bin/foot"
        ];
      };
    };
  };
}
