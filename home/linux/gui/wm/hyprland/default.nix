{
  config,
  inputs,
  lib,
  myvars,
  pkgs,
  ...
}:
with lib; let
  cfg = config.wm.hyprland;

  scrolloverviewPlugin = import ./scrolloverview.nix {inherit inputs pkgs;};

  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtNixos + "/dotfiles";
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
    ./../addons/noctalia.nix
    ./../addons/hyprlock.nix
  ];

  config = mkIf cfg.enable {
    wm.addons = {
      hyprlock.enable = true;
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

    xdg.configFile = {
      # linked individually so Home Manager can also generate files inside .config/hypr/
      "hypr/animations.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/animations.lua";
      "hypr/base.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/base.lua";
      "hypr/binds.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/binds.lua";
      "hypr/debug.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/debug.lua";
      "hypr/execs.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/execs.lua";
      "hypr/general.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/general.lua";
      "hypr/gesture.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/gesture.lua";
      "hypr/hyprlock.conf".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/hyprlock.conf";
      "hypr/input.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/input.lua";
      "hypr/others.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/others.lua";
      "hypr/scratchpad.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/scratchpad.lua";
      "hypr/windowrules.lua".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/windowrules.lua";
      "hypr/apps".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/apps";
      "hypr/apps".recursive = true;
      "hypr/hosts".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/hosts";
      "hypr/hosts".recursive = true;
      "hypr/plugins".source = mkSymlink "${dotfilesRoot}/hypr/.config/hypr/plugins";
      "hypr/plugins".recursive = true;

      # multitouch gestures
      "libinput-gestures.conf".source = mkSymlink "${dotfilesRoot}/libinput-gestures/.config/libinput-gestures.conf";
    };

    wayland.windowManager.hyprland = {
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.variables = ["--all"];

      # Use Lua config format (Hyprland >= 0.55)
      configType = "lua";

      plugins = [
        # official plugins
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
        # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
        pkgs.hyprlandPlugins.hyprbars
        # pkgs.hyprlandPlugins.hyprscrolling

        # third-party plugins
        # inputs.hycov.packages.${pkgs.stdenv.hostPlatform.system}.hycov

        # scrollable workspace overview, like niri
        scrolloverviewPlugin

        # official plugin, but WIP
        # pkgs.hyprlandPlugins.hyprscrolling

        # make Hyprland cursor more realistic(shake to find)
        # pkgs.hyprlandPlugins.hypr-dynamic-cursors

        # inputs.hyprland-easymotion.packages.${pkgs.stdenv.hostPlatform.system}.hypreasymotion
        # inputs.Hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
      ];

      extraConfig = ''
        require("base")

        -- host-based config
        require("hosts/${cfg.host}")
      '';
    };
  };
}
