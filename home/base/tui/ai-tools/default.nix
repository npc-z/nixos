{
  config,
  inputs,
  lib,
  mylib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.ai-tools;
in {
  imports =
    [
      inputs.skills-catalog.homeManagerModules.default
    ]
    ++ mylib.scanPaths ./.;

  options.modules.ai-tools = {
    enable = mkEnableOption "ai-tools" // {default = true;};
  };

  config = mkIf cfg.enable {
    programs.agent-skills.enable = true;
  };
}
