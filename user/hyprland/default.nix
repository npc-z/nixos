{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hypr.settings;
in {
  options.hypr.settings = {
    host = mkOption {
      default = "r9000p";
      example = "r9000p";
      type = types.str;
      description = ''
        hyprland config based on host
      '';
    };
  };

  config.wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    systemd.variables = ["--all"];

    plugins = [
    ];

    extraConfig = ''
      source = ~/.config/hypr/base.conf

      # host-based config
      source = ~/.config/hypr/hosts/${cfg.host}.conf

    '';
  };
}
