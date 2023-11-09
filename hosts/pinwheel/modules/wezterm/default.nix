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

          config.font = wezterm.font 'JetBrainsMono Nerd Font'
          -- to get "perfect" scaling to the right
          config.font_size = 15.2

          config.enable_tab_bar = false

          config.window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          }

          config.disable_default_key_bindings = true
          config.keys = {
            {
              key = 'C',
              mods = 'CTRL|SHIFT',
              action = wezterm.action.CopyTo "Clipboard",
            },
            {
              key = 'V',
              mods = 'CTRL|SHIFT',
              action = wezterm.action.PasteFrom "Clipboard",
            },
            {
              key = '+',
              mods = 'CTRL',
              action = wezterm.action.IncreaseFontSize,
            },
            {
              key = '-',
              mods = 'CTRL',
              action = wezterm.action.DecreaseFontSize,
            },
            {
              key = '0',
              mods = 'CTRL',
              action = wezterm.action.ResetFontSize,
            },
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
