{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.ai-tools;
in {
  options.modules.ai-tools.codex.enable = mkEnableOption "codex" // {default = true;};

  config = mkIf cfg.enable (mkIf cfg.codex.enable {
    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.codex];
  });
}
