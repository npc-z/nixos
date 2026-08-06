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
  options.modules.ai-tools.skills.enable = mkEnableOption "the open agent skills tool (npx skills)" // {default = false;};

  config = mkIf cfg.enable (mkIf cfg.skills.enable {
    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.skills];
  });
}
