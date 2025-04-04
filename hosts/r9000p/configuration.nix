{mylib, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    (mylib.relativeToRoot "modules/linux")
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
