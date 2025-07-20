{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.wm.hyprland;
in {
  options.wm.hyprland = {
    enable = mkEnableOption "enable hyprland";

    host = mkOption {
      default = "r9000p";
      example = "r9000p";
      type = types.str;
      description = ''
        hyprland config based on host
      '';
    };
  };

  imports = [
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

    home.packages = [
      # Run, show and hide programs via keybind. Emulates tdrop in Hyprland
      inputs.hyprland-contrib.packages.${pkgs.system}.hdrop
    ];

    # maybe i have to reconfig xdg
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      config.common.default = "*";
    };

    wayland.windowManager.hyprland = {
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.variables = ["--all"];

      plugins = [
        # official plugins
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
        # inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
        pkgs.hyprlandPlugins.hyprbars

        # third-party plugins
        # inputs.hycov.packages.${pkgs.system}.hycov

        # official plugin, but WIP
        # pkgs.hyprlandPlugins.hyprscrolling

        # make Hyprland cursor more realistic(shake to find)
        pkgs.hyprlandPlugins.hypr-dynamic-cursors

        # inputs.hyprland-easymotion.packages.${pkgs.system}.hypreasymotion
        # inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
      ];

      extraConfig = ''
        source = ~/.config/hypr/base.conf

        # host-based config
        source = ~/.config/hypr/hosts/${cfg.host}.conf

      '';
    };
  };
}
