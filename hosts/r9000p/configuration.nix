{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./../../system/laptop
  ];

  networking = {
    hostName = "r9000p-nixos";
  };
}
