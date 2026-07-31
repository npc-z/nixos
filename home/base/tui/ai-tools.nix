{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkMerge;
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
      enable = mkEnableOption "the open agent skills tool (npx skills)" // {default = false;};
    };
  };

  imports = [
    inputs.skills-catalog.homeManagerModules.default
  ];

  config = mkIf cfg.enable (
    let
      llmAgentsPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in (mkMerge [
      {
        programs.agent-skills.enable = true;
      }

      # opencode
      (mkIf cfg.opencode.enable {
        programs.opencode = {
          enable = true;
          package = llmAgentsPkgs.opencode;
        };

        home.sessionVariables = mkIf cfg.opencode.enable {
          # https://opencode.ai/docs/lsp/#built-in
          # disable automatic LSP server downloads
          OPENCODE_DISABLE_LSP_DOWNLOAD = true;
        };
      })

      # pi
      (mkIf cfg.pi.enable {
        home.packages = [llmAgentsPkgs.pi];
      })

      # skills
      (mkIf cfg.skills.enable {
        home.packages = [llmAgentsPkgs.skills];
      })
    ])
  );
}
