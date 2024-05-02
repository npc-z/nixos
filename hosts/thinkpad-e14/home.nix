{...}: {
  imports = [
    ./../base/home.nix
  ];

  # for hypyland config
  config.hypr.settings = {
    host = "thinkpad-e14";
  };
}
