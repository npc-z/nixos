{
  mylib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./../../system/steam.nix

    (mylib.relativeToRoot "modules/linux/configuration.nix")
  ];

  config = {
    networking = {
      hostName = "ser7-nixos";
    };

    modules = {
      ollama = {
        # enable = true;
        package = pkgs.ollama-rocm;
      };
    };
  };
}
