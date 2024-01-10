{ pkgs, lib, config, ... }:
let
  hyprlandEnabled = config.mod.hyprland.enable;
in
{
  users.users.alex.extraGroups = [ "audio" ];

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    wireplumber.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  home-manager.users.alex = {
    wayland.windowManager.hyprland = lib.mkIf hyprlandEnabled {
      settings = {
        bind = let
          toggle-output-mute = pkgs.writeShellScript "toggle-output-mute" ''
                ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
                MUTED=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep MUTED | wc -l)
                echo $MUTED > /sys/class/leds/platform::mute/brightness
          '';

          toggle-input-mute = pkgs.writeShellScript "toggle-input-mute" ''
                ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
                MUTED=$(${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep MUTED | wc -l)
                echo $MUTED > /sys/class/leds/platform::micmute/brightness
          '';
        in [
          ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+"
          ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"
          ", XF86AudioMute, exec, ${toggle-output-mute}"
          ", XF86AudioMicMute, exec, ${toggle-input-mute}"
        ];
      };
    };

    home.packages = [ pkgs.pavucontrol ];
  };
}
