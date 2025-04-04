{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (builtins) elem;
  inherit (lib.modules) mkIf;

  cfg = config.modules.gpu;
  # let me play youtube videos without h.264, please and thank you
  # vaapiIntel = pkgs.intel-vaapi-driver.override {enableHybridCodec = true;};
in {
  config = mkIf (elem cfg.type ["intel" "hybrid-intel"]) {
    # Enable the i915 kernel module
    boot.initrd.kernelModules = ["i915"];

    # Provides better performance than the actual Intel driver
    services.xserver.videoDrivers = ["modesetting"];

    # OpenCL support and VAAPI
    hardware.graphics = {
      extraPackages = with pkgs; [
        # vaapiIntel
        vaapiVdpau
        intel-compute-runtime
        intel-media-driver
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        # vaapiIntel
        vaapiVdpau
        intel-media-driver
        libvdpau-va-gl
      ];
    };

    environment.variables = mkIf (config.hardware.graphics.enable && cfg.type != "hybrid-nv") {
      VDPAU_DRIVER = "va_gl";
    };
  };
}
