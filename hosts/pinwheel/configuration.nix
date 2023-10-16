{ inputs, system, pkgs, ... }:
{
  imports =
    [
      ../../config-manager/default.nix
      ./hardware-configuration.nix
      ./modules
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    kernel = {
      sysctl = {
        "fs.inotify.max_user_instances" = 1024; # default: 128
      };
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };
  };

  services.connman = {
    enable = true;

    networkInterfaceBlacklist = [
      "vmnet"
      "vboxnet"
      "virbr"
      "ifb"
      "ve"
      "docker"
      "br-"
    ];
  };

  networking = {
    hostName = "pinwheel";

    nameservers = [
      "1.1.1.1#one.one.one.one"
      "1.0.0.1#one.one.one.one"
    ];
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  hardware.opengl.enable = true;
  programs.dconf.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "wheel" ];
  };

  environment.systemPackages = with pkgs; [
    inputs.agenix.packages."${system}".default
    inputs.nh.packages."${system}".default
    coreutils
    gnumake
    bash
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    nerdfonts
    liberation_ttf
  ];

  config-manager.flakePath = "/home/alex/config";

  mod = {
    nix-index.enable = true;
    greetd.enable = true;
    git.enable = true;
    openvpn.enable = true;
    go.enable = true;
    keyboard.enable = true;
    docker.enable = true;
    podman.enable = false;
    scripts.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
