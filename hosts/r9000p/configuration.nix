{mylib, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    (mylib.relativeToRoot "modules/linux/desktop")
  ];

  config = {
    networking = {
      hostName = "r9000p-nixos";
    };

    modules = {
      laptop.enable = true;
    };
  };
}
