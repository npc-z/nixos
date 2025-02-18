{...}: {
  imports = [
    ./../base/home.nix
  ];

  config = {
    # for hypyland config
    hypr.settings = {
      enable = true;
      host = "ser7";
    };

    modules = {
      direnv = {
        enable = true;
      };
    };
  };
}
