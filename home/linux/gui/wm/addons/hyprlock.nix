{
  config,
  lib,
  ...
}: let
  cfg = config.wm.addons.hyprlock;
in {
  options.wm.addons.hyprlock = {
    enable = lib.mkEnableOption "enable hyprlock";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;
    };
  };
}
