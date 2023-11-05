{ pkgs, lib, config, ... }:
let
  enabled = config.mod.foot.enable;

  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  options = {
    mod.foot = {
      enable = lib.mkEnableOption "enable foot module";
    };
  };

  config = {
    home-manager.users.alex = lib.mkIf enabled {
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
  };
}
