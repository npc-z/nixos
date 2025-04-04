{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.cpu;
in {
  config = lib.mkIf (builtins.elem cfg.type ["intel" "vm-intel"]) {
    hardware.cpu.intel.updateMicrocode = true;

    boot = {
      kernelModules = ["kvm-intel"];
      kernelParams = ["i915.fastboot=1" "enable_gvt=1"];
    };

    environment.systemPackages = [
      pkgs.intel-gpu-tools
    ];
  };
}
