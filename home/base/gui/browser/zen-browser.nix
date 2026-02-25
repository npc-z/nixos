{inputs, ...}: {
  imports = [
    # Use the twilight package to guarantee reproducibility,
    # the artifacts of that package are re-uploaded to this repository.
    # However, if you don't agree with that and want to use the official artifacts, use twilight-official.
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    # NOTE: remove this
    # If you haven't migrated yet, please follow the migration guide:
    # https://github.com/0xc000022070/zen-browser-flake#missing-configuration-after-update
    # To suppress this warning after completing the migration, set:
    suppressXdgMigrationWarning = true;

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
      OfferToSaveLogins = true; # Control whether or not Firefox offers to save passwords
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      ExtensionSettings = {
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
