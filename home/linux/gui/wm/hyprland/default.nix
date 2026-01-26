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
    ./../addons/hypridle.nix
    ./../addons/hyprlock.nix
    ./../addons/hyprsunset.nix
    ./../addons/waybar.nix

    ./../xdg-portal.nix
  ];

  config = mkIf cfg.enable {
    wm.addons = {
      hyprlock.enable = true;
      hyprsunset.enable = true;
      hypridle.enable = true;
      waybar.enable = true;
    };

    home.packages = with pkgs; [
      wayland-protocols
      wayland-utils
      # Fusuma is multitouch gesture recognizer
      # fusuma
      libinput-gestures

      # Run, show and hide programs via keybind. Emulates tdrop in Hyprland
      inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.hdrop
    ];

    wayland.windowManager.hyprland = {
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.variables = ["--all"];

      plugins = [
        # official plugins
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
        pkgs.hyprlandPlugins.hyprbars
        pkgs.hyprlandPlugins.hyprscrolling

        # third-party plugins
        # inputs.hycov.packages.${pkgs.stdenv.hostPlatform.system}.hycov

        # official plugin, but WIP
        # pkgs.hyprlandPlugins.hyprscrolling

        # make Hyprland cursor more realistic(shake to find)
        pkgs.hyprlandPlugins.hypr-dynamic-cursors

        # inputs.hyprland-easymotion.packages.${pkgs.stdenv.hostPlatform.system}.hypreasymotion
        # inputs.Hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
      ];

      extraConfig = ''
        source = ~/.config/hypr/base.conf

        # host-based config
        source = ~/.config/hypr/hosts/${cfg.host}.conf

      '';
    };
  };
}
