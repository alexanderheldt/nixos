{ pkgs, ... }:
{
  imports =
    [
      ../../config-manager/default.nix
      ../../shared-modules/syncthing.nix
      ./hardware-configuration.nix
      ./modules
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "vim";

  boot = {
    loader = {
      grub.enable = false;
      efi.canTouchEfiVariables = true;

      raspberryPi = {
        enable = true;
        version = 4;
      };
    };

    tmp = {
     useTmpfs = true;
    };

    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M"
    ];
  };

  hardware.enableRedistributableFirmware = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  users = {
    mutableUsers = false;

    users.root = {
      hashedPassword = "$6$3mkwaUWd8NA6XuEb$x80tETKGz6FEG.kej3v5Vh6hRNoC6bikhXogTP.zZwYtISA46JaN3RMK3ckbqt8Aj52d3krSLOfBaAR1qzuJ2/";
    };

    users."alex" = {
      isNormalUser = true;
      hashedPassword = "$6$3mkwaUWd8NA6XuEb$x80tETKGz6FEG.kej3v5Vh6hRNoC6bikhXogTP.zZwYtISA46JaN3RMK3ckbqt8Aj52d3krSLOfBaAR1qzuJ2/";
      extraGroups = [ "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [
    gnumake
    mkpasswd
    vim
    git
    tig
    unar
  ];

  config-manager = {
    flakePath = "/home/alex/config";
  };

  mod = {
    ssh.enable = true;
    docker.enable = true;
    nginx.enable = true;
    syncthing.enable = true;
    plex.enable = true;
    calibre-web.enable = true;
    transmission.enable = true;
    restic.enable = true;
  };

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
