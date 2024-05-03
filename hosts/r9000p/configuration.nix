{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./../../system/laptop/tlp.nix
  ];

  networking = {
    hostName = "r9000p-nixos";
  };

  virtualisation.docker.enable = true;
}
