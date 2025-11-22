{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.wm.niri;
in {
  options.wm.niri = {
    enable = mkEnableOption "Niri, Scrollable-tiling Wayland compositor";
  };

  imports = [
    ./../addons/hyprlock.nix
  ];

  config = mkIf cfg.enable {
    # programs.niri.enable = true;

    wm.addons = {
      hyprlock.enable = true;
    };

    home.packages = with pkgs; [
      niri
      xwayland-satellite

      inputs.noctalia.packages.${system}.default
    ];
  };
}
