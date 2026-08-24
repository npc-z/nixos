{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.obs;
in {
  options.modules.obs = {
    enable = mkEnableOption "obs-studio";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-bilibili-stream
      ];
    };
  };
}
