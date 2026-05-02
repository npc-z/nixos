{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.modules.ai-tools;
  llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.modules.ai-tools = {
    enable = mkOption {
      default = true;
      description = "Enable ai-tools";
      type = types.bool;
    };

    opencode = {
      enable = mkOption {
        default = true;
        description = "Enable opencode";
        type = types.bool;
      };
    };

    pi = {
      enable = mkOption {
        default = true;
        description = "Enable pi-mono";
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.opencode = mkIf cfg.opencode.enable {
      enable = true;
      package = llmAgentsPkgs.opencode;
    };

    home.packages = mkIf cfg.pi.enable [
      llmAgentsPkgs.pi
    ];
  };
}
