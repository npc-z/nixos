{
  mylib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    (mylib.relativeToRoot "modules/linux")
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

      game = {
        enable = true;
      };
    };
  };
}
