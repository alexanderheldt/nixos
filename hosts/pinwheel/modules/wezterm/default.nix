{ pkgs, lib, config, ... }:
let
  enabled = config.mod.wezterm.enable;

  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  options = {
    mod.wezterm = {
      enable = lib.mkEnableOption "enable wezterm module";
    };
  };

  config = {
    home-manager.users.alex = lib.mkIf enabled {
      programs.wezterm = {
        enable = true;

        extraConfig = ''
          -- Pull in the wezterm API
          local wezterm = require 'wezterm'

          local config = wezterm.config_builder()

          config.color_scheme = 'Dracula (Official)'

          -- to get "perfect" scaling to the right
          config.font_size = 12.6

          config.enable_tab_bar = false

          config.window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          }

          return config
        '';
      };

      wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
        settings = {
          bind = [
            "$mod, RETURN, exec, ${pkgs.wezterm}/bin/wezterm"
          ];
        };
      };
    };
  };
}
