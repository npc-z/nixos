{ config, lib, pkgs, ... }:

{
    imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ./../../systems
    ];

    virtualisation.docker.enable = true;

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "24.05"; # Did you read the comment?
}

