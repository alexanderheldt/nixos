# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ system, config, pkgs, agenix, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/age
      ./modules/ssh
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "pinwheel"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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
    LC_TIME = "sv_SE.UTF-8";
  };

  security.polkit.enable = true;
  hardware.opengl.enable = true;

  programs.dconf.enable = true;

  # Sound
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

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    agenix.packages."${system}".default 
  ];

  programs.zsh.enable = true;
  environment.pathsToLink = [ "/share/zsh" ];
  
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    nerdfonts   
    liberation_ttf
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    hostKeys = [{
      path = "/etc/ssh/pinwheel";
      type = "ed25519";
    }];  
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;

    cert = config.age.secrets.syncthing-cert.path;
    key = config.age.secrets.syncthing-key.path;

    user = "alex";
    group = "users";

    dataDir = "/home/alex/sync";
    
    settings = {
      devices = {
        sombrero.id = "DIKHOMV-QGZV3DR-FXQZH45-I5J5R4R-JJZS5BA-XNNW5C7-QSSU3XV-KVC4MAQ";
        phone.id = "NJIMX57-C2CGV76-GXMAQYV-ABWDA7Z-TS6UV2X-NVL5UPG-UFEQH4C-TKYA6QM";
      };

      folders = {
        org = {
          path = "/home/alex/sync/org";
          devices = [ "sombrero" "phone" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        personal = {
          path = "/home/alex/sync/personal";
          devices = [ "sombrero" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        work = {
          path = "/home/alex/sync/work";
          devices = [ "sombrero" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "phone-gps" = {
          path = "/home/alex/sync/phone-gps";
          devices = [ "phone" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "time-tracking" = {
          path = "/home/alex/sync/time-tracking";
          devices = [ "phone" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };
      };
    };
  };

  security.pam.services.swaylock.text = ''
    # PAM configuration file for the swaylock screen locker. By default, it includes
    # the 'login' configuration file (see /etc/pam.d/login)
    auth include login
  '';

  age = {
    secrets = {
      "syncthing-cert".file = ../../secrets/pinwheel/syncthing-cert.age;
      "syncthing-key".file = ../../secrets/pinwheel/syncthing-key.age;
    };
  };
  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
