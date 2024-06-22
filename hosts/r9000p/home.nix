{...}: {
  imports = [
    ./../base/home.nix
  ];

  # for hypyland config
  config.hypr.settings = {
    enable = true;
    host = "r9000p";
  };
}
