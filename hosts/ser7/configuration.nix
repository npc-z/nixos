{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../system/steam.nix

    ./../../system/ollama/ser7.nix
  ];

  nixpkgs.config.rocmSupport = true;

  networking = {
    hostName = "ser7-nixos";
  };
}
