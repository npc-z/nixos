{
  config,
  lib,
  ...
}: let
  cfg = config.modules.opencode;
in {
  options.modules.opencode = {
    enable = lib.mkEnableOption "enable opencode";
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
    };
  };
}
