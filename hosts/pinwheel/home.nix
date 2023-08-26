{ pkgs, lib, ... }:
{
  programs.home-manager.enable = true;

  home.username = "alex";
  home.homeDirectory = "/home/alex";
 
  home.packages = with pkgs; [
    emacs
    gnumake
    tig
    bemenu
  ];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "HDMI-A-1"
        ];
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "custom/hello-from-waybar" ];
        modules-right = [ ];
    
        "custom/hello-from-waybar" = {
          format = "hello {}";
          max-length = 40;
          interval = "once";
          exec = pkgs.writeShellScript "hello-from-waybar" ''
            echo "from within waybar"
          '';
        };
      };
    };

   style = '''';

  programs.swaylock = {
    enable = true;

    settings = {
      color = "000000";
      indicator-idle-visible = false;
      show-failed-attempts = true;
    };
  };

  services.dunst.enable = true;

  home.stateVersion = "23.05";
}
