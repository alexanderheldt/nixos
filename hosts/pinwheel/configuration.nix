{ pkgs, ... }:
{
  imports =
    [
      ../../config-manager/default.nix
      ../../nix-wrapper/default.nix
      ../../shared-modules/syncthing.nix
      ./hardware-configuration.nix
      ./modules
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    coreutils
    gnumake
    bash
    man-pages
  ];

  config-manager = {
    flakePath = "/home/alex/config";
  };

  nix-wrapper = {
    flakesPath = "/home/alex/code/own/flakes";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
