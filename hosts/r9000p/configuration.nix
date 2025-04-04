{mylib, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    (mylib.relativeToRoot "modules/linux/desktop")
  ];

  config = {
    networking = {
      hostName = "r9000p-nixos";
    };

    modules = {
      # NOTE:
      usrEnv.isWayland = true;

      cpu = {
        type = "amd";
        amd = {
          # load pstate module in case the device has a newer gpu
          pstate.enable = true;
          # zenpower is for reading cpu info, i.e voltage
          zenpower.enable = true;
        };
      };
      gpu.type = "hybrid-nv";

      laptop.enable = true;
    };
  };
}
