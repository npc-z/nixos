{
  config,
  inputs,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.ai-tools;

  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;
in {
  options.modules.ai-tools.opencode.enable = mkEnableOption "opencode" // {default = true;};

  config = mkIf cfg.enable (mkIf cfg.opencode.enable {
    home.shellAliases = {
      opencode = "opencode2";
    };

    programs.opencode = {
      enable = true;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2;
    };

    xdg.configFile = {
      "opencode/opencode.jsonc" = linkFile "opencode/opencode.jsonc";
      "opencode/cli.json" = linkFile "opencode/cli.json";
    };
  });
}
