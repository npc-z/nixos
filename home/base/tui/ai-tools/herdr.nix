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
  options.modules.ai-tools.herdr.enable = mkEnableOption "herdr" // {default = true;};

  config = mkIf cfg.enable (mkIf cfg.herdr.enable {
    programs.herdr = {
      enable = true;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.herdr;
    };
  });
}
