{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  networking = {
    hostName = "ser7-nixos";
  };

  virtualisation.docker.enable = true;
}
