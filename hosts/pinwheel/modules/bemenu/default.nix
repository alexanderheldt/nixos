{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;

  bmr =
    let
      foreground = "#f9c22b";
      foreground-dim = "#a57b06";
      background = "#262626";
    in
      pkgs.writeShellScript "bmr" ''
      ${pkgs.bemenu}/bin/bemenu-run \
        --fn 'DejaVuSansM Nerd Font Mono 16' \
        --hp 10 \
        --line-height 38 \
        --cw 12 \
        --ch 25 \
        --fixed-height \
        --ff "${foreground}" --fb "${background}" \
        --hf "${foreground}" --hb "${background}" \
        --af "${foreground-dim}" --ab "${background}" \
        --nf "${foreground-dim}" --nb "${background}" \
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
