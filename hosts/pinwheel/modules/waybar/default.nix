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

      style = let
        foreground = "#f9c22b";
        foreground-dim = "#a57b06";
        background = "#262626";
      in
        ''
        * {
          margin-right: 2px;
        }

        #workspaces button {
          color: ${foreground-dim};
          background-color: ${background};
          border: none;
        }

        #workspaces button:hover {
          border-color: transparent;
          background: none;
          transition: none;
          text-shadow: none;
          box-shadow: none;
        }

        #workspaces button.active {
          color: ${foreground};
          background-color: ${background};
        }

        window#waybar {
          color: ${foreground};
          background-color: ${background};
        }

        #custom-hello {
          color: ${foreground};
          background-color: ${background};
        }
      '';
    };
  };
}
