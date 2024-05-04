{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./../../system/laptop
  ];

  networking = {
    hostName = "thinkpad-e14-nixos";
  };
}
