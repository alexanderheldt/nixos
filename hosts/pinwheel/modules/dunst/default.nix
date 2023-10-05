
{ pkgs, ... }:
{
  home-manager.users.alex = {
    services.dunst = {
      enable = true;

      settings = {
        global = {
          monitor = 1;
          width = 300;
          height = 300;
          offset = "10x50";
          origin = "top-right";
          transparency = 10;
          frame_color = "#a57b06";
          font = "DejaVuSansM Nerd Font Mono 14";
        };

        urgency_low = {
          background = "#222222";
          foreground = "#888888";
          timeout = 10;
        };

        urgency_normal = {
          background = "#262626";
          foreground = "#f9c22b";
          timeout = 10;
        };

        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 10;
        };
      };
    };

    home.packages = [ pkgs.libnotify ];
  };
}
