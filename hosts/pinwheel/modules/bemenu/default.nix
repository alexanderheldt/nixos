{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;

  bmr = pkgs.writeShellScript "bmr" ''
    ${pkgs.bemenu}/bin/bemenu-run \
      --fn 'DejaVuSansM Nerd Font Mono 16' \
      --hp 10 \
      --line-height 38 \
      --cw 12 \
      --ch 25 \
      --fixed-height \
      --ff "#${config.lib.colors.foreground}" --fb "#${config.lib.colors.background}" \
      --hf "#${config.lib.colors.foreground}" --hb "#${config.lib.colors.background}" \
      --af "#${config.lib.colors.foreground-dim}" --ab "#${config.lib.colors.background}" \
      --nf "#${config.lib.colors.foreground-dim}" --nb "#${config.lib.colors.background}" \
      --prompt ""
  '';
in
{
  home-manager.users.alex = {
    home.packages = [ pkgs.bemenu ];

    wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
      settings = {
        bind = [ "$mod, SPACE, exec, ${bmr}" ];
      };
    };
  };
}
