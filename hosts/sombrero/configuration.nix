# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  environment.variables.EDITOR = "vim";

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      grub.enable = false;
      efi.canTouchEfiVariables = true;

      raspberryPi = {
        enable = true;
        version = 4;
      };
    };

    tmpOnTmpfs = true;
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

  networking = {
    hostName = "sombrero";

    defaultGateway = "192.168.50.1";
    nameservers = [ "8.8.8.8" ];
    interfaces = {
      eth0 = {
        ipv4 = {
          addresses = [{
            address = "192.168.50.200";
            prefixLength = 24;
          }];
        };
      };
    };

    firewall = {
      allowedTCPPorts = [
        80
        443
        1122  # ssh
        32400 # plex
        8181  # books-sync
        8384  # syncthing
        8083  # calibre-web
      ];
    };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "alex@a2x.se";

  services = {
    nginx = {
      enable = true;

      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."books.sombrero.a2x.se" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8083";
        };
      };

      virtualHosts."books-sync.sombrero.a2x.se" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8181";
        };
      };

      virtualHosts."syncthing.sombrero.a2x.se" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          proxyPass = "http://0.0.0.0:8384";
        };
      };
    };

    openssh = {
      enable = true;
      ports = [ 1122 ];
    };

    transmission = {
      enable = true;
      openFirewall = true;
      openRPCPort = true;
      settings.rpc-port = 9191;
      settings.rpc-bind-address = "0.0.0.0";

      user = "alex";
      group = "users";

      home = "/home/alex/media/ts-home";
      downloadDirPermissions = "775";

      settings = {
        incomplete-dir-enabled = false;
        download-dir = "/home/alex/media";

        rpc-authentication-required = true;
        rpc-whitelist-enabled = false;
        rpc-username = "transmission";
        rpc-password = "{55d884e4042db67313da49e05d7089a368eb64b3Br.3X.Xi";
      };
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true;

      user = "alex";
      group = "users";

      dataDir = "/home/alex/backup/sync";

      cert = "/home/alex/backup/sync/hosts/sombrero/syncthing/cert.pem";
      key = "/home/alex/backup/sync/hosts/sombrero/syncthing/key.pem";

      guiAddress = "0.0.0.0:8384";
      extraOptions = {
        gui = {
          user = "syncthing";
          password = "CBLPEBrHoGPOnfdZtLibnSAaPAALXfSU";
          insecureSkipHostcheck = false;
        };
      };

      devices = {
        "phone" = {
          id = "NJIMX57-C2CGV76-GXMAQYV-ABWDA7Z-TS6UV2X-NVL5UPG-UFEQH4C-TKYA6QM";
        };
        "bennu" = {
          id = "YXA2PVY-XNUS5HZ-4ZC6A65-O3JRY3S-P6UKE6N-FSUBOYE-JZ7UJWR-ILXMUAW";
        };
      };

      folders = {
        "hosts" = {
          path = "/home/alex/backup/sync/hosts";
          devices = [ "bennu" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "org" = {
          path = "/home/alex/backup/sync/org";
          devices = [ "phone" "bennu" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "phone-gps" = {
          path = "/home/alex/backup/sync/gps";
          devices = [ "bennu" "phone" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "personal" = {
          path = "/home/alex/backup/sync/personal";
          devices = [ "bennu" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "work" = {
          path = "/home/alex/backup/sync/work";
          devices = [ "bennu" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "books" = {
          path = "/home/alex/backup/books";
          devices = [ "bennu" ];
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
        };

        "audiobooks" = {
          path = "/home/alex/media/sync/audiobooks";
          devices = [ "phone" ];
        };
      };
    };

    restic.backups = {
      "sync" = {
        initialize = true;

        user = "alex";

        passwordFile = "/home/alex/backup/restic/password.file";
        environmentFile = "/home/alex/backup/restic/aws.env";
        repository = "s3:https://s3.eu-north-1.amazonaws.com/restic-sync-backup";

        paths = ["/home/alex/backup/sync"];

        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };

        pruneOpts = [
          "--keep-daily 2"
          "--keep-weekly 7"
          "--keep-yearly 12"
        ];
      };
    };

    calibre-web = {
      enable = true;

      user = "alex";
      group = "users";

      listen = {
        ip = "127.0.0.1";
        port = 8083;
      };

      options = {
        calibreLibrary = "/home/alex/backup/books";
        enableBookUploading = true;
      };
    };
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
    };

    oci-containers.containers = {
      plex = {
        image = "linuxserver/plex";
        autoStart = true;

        environment = {
          TZ = "Europe/Stockholm";
          VERSION = "latest";
        };

        extraOptions = [ "--network=host" ];

        volumes = [
          "/home/alex/media/plex/db:/config"
          "/home/alex/media/Movies:/movies"
          "/home/alex/media/TV:/tv"
        ];
      };

      koreader-sync = {
        image = "localhost/koreader-sync";
        autoStart = true;

        extraOptions = [ "--network=host" ];

        volumes = [
          "/home/alex/backup/book-progress/:/book-progress"
        ];
      };
    };
  };

  users = {
    mutableUsers = false;

    users.root = {
      hashedPassword = "$6$3mkwaUWd8NA6XuEb$x80tETKGz6FEG.kej3v5Vh6hRNoC6bikhXogTP.zZwYtISA46JaN3RMK3ckbqt8Aj52d3krSLOfBaAR1qzuJ2/";
    };

    users."alex" = {
      isNormalUser = true;
      hashedPassword = "$6$3mkwaUWd8NA6XuEb$x80tETKGz6FEG.kej3v5Vh6hRNoC6bikhXogTP.zZwYtISA46JaN3RMK3ckbqt8Aj52d3krSLOfBaAR1qzuJ2/";
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD8g63nIaOg67kwwEd5cGXvzaTL1PefLwonKkDy1P2cJjngcH/cBmgzXUZWxWqgBIENZ3mj0EJtoD556tprRRFj9COdAEI9bxn2NkoqPCu8f7SttQTeVA63ZbAR7AHPMMngBxRiQy6SIo6mQteXha1z99+g0YHETct/qhmm2AbtakF+NSb0bIqrFYnOl7iSW4cotGjibAyX74b4dBe9A2sIYwmBs4IMjLlHmcrmqLqPIAGWY1EgNV/HIN06whbkSjpoxaFAZpxoVskk/syjzD/RRSLnFhXbljZeRkUp1nFsELNGgugQo3fx1oxigfgzo09QSRDuB6eb2Ol1XnnNU0vcJPio9PmIR9aOiinVx/i/N0QvQtedoxNgLR4bayJrOxL7wYvWGW50TCLEIZ+OnPp6HW5mGHaOWjeKymjBCXpQumTcv3TBZpsHvQ5vbTU2otbbof/1ScEzfS9XBxWPH89dua1aPBcHk58jGbNz7jRLBPNSmDgvuIMAeavrDbHu5p22XnHOPz9f2aCkX2M6ll17mN1dMc8v6/i9/gV7bmSj+DAwQEjxtYd1eQFGw9VvmDfTdzpBhLmnNAIdbHJo3WMsY0AZCvov0mEu7qJA8hrmm4ITb9pO0ZhfYfF1bZVbYfKAdF3hWPn5vxQFXKUogSXjU8lIn6Bu+Vw40IteDy2aKQ== alex.bennu@sombrero"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    gnumake
    mkpasswd
    vim
    git
    tig
    transmission
    calibre-web
    unar
    restic
  ];

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
