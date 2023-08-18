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
in
{
  programs.firefox = {
    enable = true;

    package = wrapped;

    profiles = {
      alex = {
        id = 0;
        name = "alex";
      };

      work = {
        id = 1;
        name = "work";
      };
    };
  };

  home.packages = [ ff ];
}
