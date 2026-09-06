{
  config,
  lib,
  myvars,
  pkgs,
  ...
}: let
  cfg = config.home-gui.flameshot;

  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtNixos + "/dotfiles";
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
      source = mkSymlink "${dotfilesRoot}/flameshot";
      recursive = true;
    };
  };
}
