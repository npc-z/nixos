{
  config,
  inputs,
  lib,
  mylib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.hypr.settings;
in {
  options.hypr.settings = {
    enable = mkEnableOption "enable hyprland";

    host = mkOption {
      default = "r9000p";
      example = "r9000p";
      type = types.str;
      description = ''
        hyprland config based on host
      '';
    };

    hypridle = {
      lock_timeout = mkOption {
        description = "lock screen timeout in seconds";
        default = 300;
        example = 300;
        type = types.int;
      };

      dpms_off_timeout = mkOption {
        description = "dpms off timeout in seconds";
        default = 600;
        example = 600;
        type = types.int;
      };
    };
  };

  imports = mylib.scanPaths ./.;

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      wayland-protocols
      wayland-utils
      # Fusuma is multitouch gesture recognizer
      # fusuma
      libinput-gestures
      # hyprsunset a blue-light filter on Hyprland
      hyprsunset

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

        # inputs.hyprscroller.packages.${pkgs.system}.hyprscroller
        pkgs.hyprlandPlugins.hyprscroller

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
