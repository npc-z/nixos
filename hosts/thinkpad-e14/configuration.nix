{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./../../system/laptop
  ];

  config.networking = {
    hostName = "thinkpad-e14-nixos";
  };

  # for dwm config
  config.dwm.settings = {
    enable = false;
    enable_startx = false;
  };
}
