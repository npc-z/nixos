{
  mylib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    (mylib.relativeToRoot "modules/linux/desktop")
  ];

  config = {
    networking = {
      hostName = "ser7-nixos";
    };

    modules = {
      cpu = {
        type = "amd";
        amd = {
          # load pstate module in case the device has a newer gpu
          pstate.enable = true;
          # zenpower is for reading cpu info, i.e voltage
          zenpower.enable = true;
        };
      };

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
