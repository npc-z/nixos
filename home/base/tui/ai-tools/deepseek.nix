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

    services.dsh = {
      enable = true;
      port = 3080;
      # Serve one of the profiles declared above: the module's `nix-web`
      # fallback composes `pkgs.dsh.presets.web` through `.override`, which
      # re-invokes the preset lambda and rejects composition arguments.
      profile = config.programs.dsh.profiles.web-ui.materializedName;
    };

    programs.dsh = {
      enable = true;

      profiles.tui = {
        bundles = [
          pkgs.dsh.bundles.notification
          pkgs.dsh.bundles.tui
        ];
      };

      profiles.web-ui = {
        bundles = [
          pkgs.dsh.bundles.notification
          pkgs.dsh.bundles.web-ui
        ];
      };

      # defaultProfile = "nix-tui";
      defaultProfile = "nix-web-ui";
    };
  });
}
