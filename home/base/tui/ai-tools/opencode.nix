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
  options.modules.ai-tools.opencode.enable = mkEnableOption "opencode" // {default = true;};

  config = mkIf cfg.enable (mkIf cfg.opencode.enable {
    programs.opencode = {
      enable = true;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
    };

    home.sessionVariables = {
      # https://opencode.ai/docs/lsp/#built-in
      # disable automatic LSP server downloads
      OPENCODE_DISABLE_LSP_DOWNLOAD = true;
    };
  });
}
