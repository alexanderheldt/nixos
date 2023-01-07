# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.grub.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  boot.loader.raspberryPi = {
    enable = true;
    version = 4;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  networking = {
    hostName = "sombrero";
    wireless = {
      enable = true;
      networks."pretty-fly-for-a-wifi".psk = "latkatt1";
      interfaces = [
        "wlan0"
      ];
    };
  };

  services.openssh.enable = true;
  services.openssh.ports = [ 1122 ];
  networking.firewall.allowedTCPPorts = [ 1122 ];

  users = {
    mutableUsers = false;
    users."alex" = {
      isNormalUser = true;
      password = "alex";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD8g63nIaOg67kwwEd5cGXvzaTL1PefLwonKkDy1P2cJjngcH/cBmgzXUZWxWqgBIENZ3mj0EJtoD556tprRRFj9COdAEI9bxn2NkoqPCu8f7SttQTeVA63ZbAR7AHPMMngBxRiQy6SIo6mQteXha1z99+g0YHETct/qhmm2AbtakF+NSb0bIqrFYnOl7iSW4cotGjibAyX74b4dBe9A2sIYwmBs4IMjLlHmcrmqLqPIAGWY1EgNV/HIN06whbkSjpoxaFAZpxoVskk/syjzD/RRSLnFhXbljZeRkUp1nFsELNGgugQo3fx1oxigfgzo09QSRDuB6eb2Ol1XnnNU0vcJPio9PmIR9aOiinVx/i/N0QvQtedoxNgLR4bayJrOxL7wYvWGW50TCLEIZ+OnPp6HW5mGHaOWjeKymjBCXpQumTcv3TBZpsHvQ5vbTU2otbbof/1ScEzfS9XBxWPH89dua1aPBcHk58jGbNz7jRLBPNSmDgvuIMAeavrDbHu5p22XnHOPz9f2aCkX2M6ll17mN1dMc8v6/i9/gV7bmSj+DAwQEjxtYd1eQFGw9VvmDfTdzpBhLmnNAIdbHJo3WMsY0AZCvov0mEu7qJA8hrmm4ITb9pO0ZhfYfF1bZVbYfKAdF3hWPn5vxQFXKUogSXjU8lIn6Bu+Vw40IteDy2aKQ== alex.bennu@sombrero"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

    # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
