{
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkIf;
  cfg = config.modules.shell;
in {
  options.modules = {
    shell.tirith = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable the tirith shell security monitor.";
      };

      enableBashIntegration = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable tirith integration for bash.";
      };

      enableZshIntegration = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to enable tirith integration for zsh.";
      };
    };
  };

  config = mkIf cfg.tirith.enable {
    programs.tirith = {
      enable = true;
      enableBashIntegration = cfg.tirith.enableBashIntegration;
      enableZshIntegration = cfg.tirith.enableZshIntegration;
    };
  };
}
