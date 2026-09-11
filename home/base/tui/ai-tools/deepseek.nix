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
  options.modules.ai-tools.deepseek.enable = mkEnableOption "deepsekk" // {default = true;};

  imports = [inputs.deepseek-harness.homeModules.default];

  config = mkIf cfg.enable (mkIf cfg.deepseek.enable {
    # home.packages = [inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.dsh];

    programs.dsh = {
      enable = true;

      profiles.tui = {
        bundles = [pkgs.dsh.bundles.tui];
        mode = "mutable";
      };
      profiles.web-ui = {
        bundles = [pkgs.dsh.bundles.web-ui];
        mode = "mutable";
      };

      # defaultProfile = "nix-tui";
      defaultProfile = "nix-web-ui";
    };
  });
}
