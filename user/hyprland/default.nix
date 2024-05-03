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

  # maybe i have to reconfig xdg
  config.xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  config.wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland.enable = true;
    systemd.enable = true;
    systemd.variables = ["--all"];

    plugins = [
      # official plugins
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo

      # third-party plugins
      inputs.hycov.packages.${pkgs.system}.hycov
      # inputs.hyprland-easymotion.packages.${pkgs.system}.hypreasymotion
      # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];

    extraConfig = ''
      source = ~/.config/hypr/base.conf

      # host-based config
      source = ~/.config/hypr/hosts/${cfg.host}.conf

    '';
  };
}
