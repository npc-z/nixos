{
  inputs,
  system,
  pkgs,
  ...
}: {
  imports = [
    # Use the twilight package to guarantee reproducibility,
    # the artifacts of that package are re-uploaded to this repository.
    # However, if you don't agree with that and want to use the official artifacts, use twilight-official.
    inputs.zen-browser.homeModules.twilight
  ];

  # xdg.mimeApps = let
  #   associations = builtins.listToAttrs (map (name: {
  #       inherit name;
  #       value = let
  #         zen-browser = inputs.zen-browser.packages.${stdenv.hostPlatform.system}.twilight;
  #       in
  #         zen-browser.meta.desktopFile;
  #     }) [
  #       "application/x-extension-shtml"
  #       "application/x-extension-xhtml"
  #       "application/x-extension-html"
  #       "application/x-extension-xht"
  #       "application/x-extension-htm"
  #       "x-scheme-handler/unknown"
  #       "x-scheme-handler/mailto"
  #       "x-scheme-handler/chrome"
  #       "x-scheme-handler/about"
  #       "x-scheme-handler/https"
  #       "x-scheme-handler/http"
  #       "application/xhtml+xml"
  #       "application/json"
  #       "text/plain"
  #       "text/html"
  #     ]);
  # in {
  #   associations.added = associations;
  #   defaultApplications = associations;
  # };

  home.packages = with pkgs; [
    microsoft-edge
    firefox
    # google-chrome
  ];

  programs.zen-browser = {
    enable = true;
    policies = let
      locked = value: {
        Value = value;
        Status = "locked";
      };
    in {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;
      # DisablePocket = true; # save webs for later reading
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true; # Disable the creation of default bookmarks
      OfferToSaveLogins = false; #Control whether or not Firefox offers to save passwords
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      ExtensionSettings = {
        "wappalyzer@crunchlabz.com" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/wappalyzer/latest.xpi";
          installation_mode = "force_installed";
        };
        "{85860b32-02a8-431a-b2b1-40fbd64c9c69}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/github-file-icons/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      Preferences = builtins.mapAttrs (_: locked) {
        "browser.tabs.warnOnClose" = false;
        "media.videocontrols.picture-in-picture.video-toggle.enabled" = true;
      };
    };
  };
}
