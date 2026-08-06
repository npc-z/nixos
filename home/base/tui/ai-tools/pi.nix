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
  options.modules.ai-tools.pi.enable = mkEnableOption "pi-mono" // {default = true;};

  config = mkIf cfg.enable (mkIf cfg.pi.enable {
    home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi];
  });
}
