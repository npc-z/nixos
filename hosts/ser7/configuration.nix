{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../system/steam.nix
  ];

  networking = {
    hostName = "ser7-nixos";
  };
}
