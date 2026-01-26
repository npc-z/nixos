{
  config,
  lib,
  ...
}: let
  cfg = config.wm.addons.hyprsunset;
in {
  options.wm.addons.hyprsunset = {
    enable = lib.mkEnableOption "hyprsunset a blue-light filter on Hyprland";
  };

  config = lib.mkIf cfg.enable {
    services.hyprsunset = {
      enable = true;
    };
  };
}
