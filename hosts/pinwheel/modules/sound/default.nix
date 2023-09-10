{ pkgs, ... }:
{
  users.users.alex.extraGroups = [ "audio" ];

  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    wireplumber.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  home-manager.users.alex = {
    wayland.windowManager.hyprland = {
      settings = {
        bind = [
          ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+"
          ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
          ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ];
      };
    };

    home.packages = [ pkgs.pavucontrol ];
  };
}
