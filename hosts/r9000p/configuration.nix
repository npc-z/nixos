{mylib, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./../../system/laptop

    (mylib.relativeToRoot "modules/linux")
  ];

  config = {
    networking = {
      hostName = "r9000p-nixos";
    };
  };
}
