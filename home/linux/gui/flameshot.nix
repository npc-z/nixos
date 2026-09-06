{
  config,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  cfg = config.home-gui.flameshot;

  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  options.home-gui.flameshot = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable flameshot";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Powerful yet simple to use screenshot software
      # https://github.com/flameshot-org/flameshot
      flameshot
    ];

    xdg.configFile.flameshot = {
      source = link "flameshot";
      recursive = true;
    };
  };
}
