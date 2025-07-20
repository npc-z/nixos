{
  config,
  inputs,
  lib,
  ...
}:
with lib; let
  cfg = config.wm.maomaowm;
in {
  options.wm.maomaowm = {
    enable = mkEnableOption "maomaowm";
  };

  imports = [
    # Add maomaowm hm module
    inputs.maomaowm.hmModules.maomaowm
    ./../wayland
    ./../addons/hypridle.nix
    ./../addons/hyprlock.nix
    ./../addons/hyprsunset.nix
    ./../addons/waybar.nix
  ];

  config = mkIf cfg.enable {
    wm.addons = {
      hyprlock.enable = true;
      hyprsunset.enable = true;
      hypridle.enable = true;
      waybar.enable = true;
    };

    wayland.windowManager.maomaowm = {
      enable = true;

      # settings = ''
      #   # see config.conf
      # '';
      #
      # autostart_sh = ''
      #   # see autostart.sh
      #   # Note: here no need to add shebang
      # '';
    };
  };
}
