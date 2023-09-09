{ pkgs, ... }:
{
  home-manager.users.alex = {
    programs.waybar = {
      enable = true;

      settings = {
        bar1 = {
          name = "bar1";
          layer = "top";
          position = "top";
          height = 30;
          output = [
            "eDP-1"
            "HDMI-A-1"
          ];

          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ "custom/hello" ];
          modules-right = [ "tray" "wireplumber" "battery" "clock" ];

          "custom/hello" = {
            format = "hello {}";
            max-length = 40;
            interval = "once";
            exec = pkgs.writeShellScript "hello-from-waybar" ''
              echo "from within waybar"
            '';
          };

          wireplumber = {
            format = "{volume}%";
            format-muted = "";
            on-click = "pavucontrol";
            max-volume = 150;
            scroll-step = 0.2;
          };
        };
      };

     style = ''
       #workspaces button.active {
         background: red;
       }

       window#waybar {
         background-color: blue;
       }

       #custom-hello {
         background-color: yellow;
       }
     '';
    };
  };
}
