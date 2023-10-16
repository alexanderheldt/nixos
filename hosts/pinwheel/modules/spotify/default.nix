{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  home-manager.users.alex = {
    home.packages = with pkgs; [
      spotify
      playerctl
    ];

    wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
      settings = {
        bind = [
          "$mod ALT, LEFT, exec, ${pkgs.playerctl}/bin/playerctl -p spotify previous"
          "$mod ALT, RIGHT, exec, ${pkgs.playerctl}/bin/playerctl -p spotify next"
          "$mod ALT, DOWN, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"
        ];
      };
    };
  };
}
