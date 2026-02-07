{
  config,
  lib,
  ...
}: let
  cfg = config.modules.opencode;
in {
  options.modules.opencode = {
    enable = lib.mkOption {
      default = true;
      description = "Whether to enable opencode";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
    };
  };
}
