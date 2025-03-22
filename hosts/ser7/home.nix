{...}: {
  imports = [
    ./../base/home.nix
  ];

  config = {
    # for hypyland config
    hypr.settings = {
      enable = true;
      host = "ser7";
      hypridle = {
        lock_timeout = 60 * 30; # in seconds
        dpms_off_timeout = 60 * 60; # in seconds
      };
    };

    modules = {
      direnv = {
        enable = true;
      };
    };
  };
}
