{
  config,
  lib,
  ...
}: let
  cfg = config.wm.addons.waybar;
in {
  options.wm.addons.waybar = {
    enable = lib.mkEnableOption "waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      # systemd.enable = true; # Whether to enable Waybar systemd integration
    };
  };
}
