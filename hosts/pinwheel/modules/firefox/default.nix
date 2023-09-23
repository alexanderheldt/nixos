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
      ${wrapped}/bin/firefox -p
    '';
  };

  sharedSettings = {
    "general.autoscroll" = false;
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

    home.packages = [ ff ];
  };
}
