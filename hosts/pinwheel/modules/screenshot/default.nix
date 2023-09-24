{ inputs, pkgs, system, ...}:
let
  grimblast = inputs.hyprland-contrib.packages.${system}.grimblast;
  area = "${pkgs.libnotify}/bin/notify-send 'ps: selected area' && ${grimblast}/bin/grimblast copy area";
  screen = "${pkgs.libnotify}/bin/notify-send 'ps: selected screen' &&${grimblast}/bin/grimblast copy output";
in
{
  home-manager.users.alex = {
    home.packages = [ grimblast ];

    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          "$mod, Print, exec, ${area}"
          "$mod CTRL, Print, exec, ${screen}"
        ];
      };
    };
  };
}
