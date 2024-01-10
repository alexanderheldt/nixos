{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  home-manager.users.alex = {
    wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
      settings = {
        bind = let
          prev = "${pkgs.playerctl}/bin/playerctl -p spotify previous";
          next = "${pkgs.playerctl}/bin/playerctl -p spotify next";
        in [
          ", XF86AudioPrev, exec, ${prev}"
          ", XF86AudioNext, exec, ${next}"
          ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"
          ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl -p spoitfy play-pause"

          "$mod ALT, LEFT, exec, ${prev}"
          "$mod ALT, RIGHT, exec, ${next}"
          "$mod ALT, DOWN, exec, ${pkgs.playerctl}/bin/playerctl -p spotify play-pause"
        ];
      };
    };

    home.packages = [
      pkgs.playerctl
      pkgs.spotify
    ];
  };

  systemd.user.services.playerctld = {
    unitConfig = {
      Description = "starts playerctld daemon";
    };

    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.playerctl}/bin/playerctld";
    };
  };
}
