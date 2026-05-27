{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf optionals;
  cfg = config.modules.ai-tools;
in {
  options.modules.ai-tools = with lib; {
    enable = mkEnableOption "ai-tools" // {default = true;};

    opencode = {
      enable = mkEnableOption "opencode" // {default = true;};
    };

    pi = {
      enable = mkEnableOption "pi-mono" // {default = true;};
    };

    skills = {
      enable = mkEnableOption "the open agent skills tool (npx skills)" // {default = true;};
    };
  };

  config = mkIf cfg.enable (let
    llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  in {
    programs.opencode = mkIf cfg.opencode.enable {
      enable = true;
      package = llmAgentsPkgs.opencode;
    };

    home.packages =
      optionals cfg.pi.enable [llmAgentsPkgs.pi]
      ++ optionals cfg.skills.enable [llmAgentsPkgs.skills];
  });
}
