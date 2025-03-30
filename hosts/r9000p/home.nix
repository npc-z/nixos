{mylib, ...}: {
  imports = [
    (mylib.relativeToRoot "home/linux/home.nix")
  ];

  config = {
    # for hypyland config
    hypr.settings = {
      enable = true;
      host = "r9000p";
    };

    modules = {
      direnv = {
        enable = true;
      };
    };
  };
}
