{...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./../../system/laptop/tlp.nix
  ];

  networking = {
    hostName = "thinkpad-e14-nixos";
  };

  virtualisation.docker.enable = true;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "24.05"; # Did you read the comment?
}
