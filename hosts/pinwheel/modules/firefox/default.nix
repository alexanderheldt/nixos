{ pkgs, ... }:
let
  wrapped = pkgs.wrapFirefox pkgs.firefox-devedition-unwrapped {
    extraPolicies = {
      DisableFirefoxAccounts = false;
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;

      FirefoxHome = {
        Search = false;
        Pocket = false;
        Snippets = false;
        TopSites = false;
        Highlights = false;
      };

      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };
  };

  ff = pkgs.writeShellApplication {
    name = "ff";
    text = ''
      ${wrapped}/bin/firefox --ProfileManager
    '';
  };

  ff-alex = pkgs.writeShellApplication {
    name = "ff-alex";
    text = ''
      ${wrapped}/bin/firefox -P alex --new-window "$@"
    '';
  };

  sharedSettings = {
    "general.smoothScroll" = true;
    "apz.gtk.kinetic_scroll.enabled" = false;
    "network.dns.force_waiting_https_rr" = false;
  };
in
{
  home-manager.users.alex = {
    programs.firefox = {
      enable = true;

      package = wrapped;

      profiles = {
        alex = {
          id = 0;
          name = "alex";
          isDefault = true;

          settings = sharedSettings // {};
        };

        work = {
          id = 1;
          name = "work";

          settings = sharedSettings // {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          };

          userChrome = ''
            .tab-content {
              border-top: solid #9400FF !important;
            }
          '';
        };
      };
    };

    xdg = {
      # /etc/profiles/per-user/alex/share/applications
      desktopEntries = {
        ff-alex = {
          name = "ff-alex";
          exec = "${ff-alex}/bin/ff-alex %U";
          terminal = false;
        };
      };

      mimeApps = {
        enable = true;

        defaultApplications = {
          "text/html" = "ff-alex.desktop";
          "x-scheme-handler/http" = "ff-alex.desktop";
          "x-scheme-handler/https" = "ff-alex.desktop";
          "application/x-exension-htm" = "ff-alex.desktop";
          "application/x-exension-html" = "ff-alex.desktop";
          "application/x-exension-shtml" = "ff-alex.desktop";
          "application/xhtml+xml" = "ff-alex.desktop";
          "application/x-exension-xhtml" = "ff-alex.desktop";
          "application/x-exension-xht" = "ff-alex.desktop";
        };
      };

      # https://github.com/nix-community/home-manager/issues/1213
      configFile."mimeapps.list".force = true;
    };


    home.packages = [ ff ff-alex ];
  };

  environment.variables.BROWSER = "${ff-alex}/bin/ff-alex $@";
}
