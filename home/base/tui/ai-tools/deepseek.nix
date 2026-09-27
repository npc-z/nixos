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
    # service only works on Linux
    services.dsh = mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      port = 3080;
      autoStart = false;
      profile = "nix-web";
    };

    programs.dsh = {
      enable = true;

      desktop = {
        enable = true;
        profile = "nix-desktop";
      };

      profiles.desktop = {
        bundles = [
        ];
        mode = "mutable";
      };

      profiles.web = {
        bundles = [
          pkgs.dsh.bundles.notification
          pkgs.dsh.bundles.web-ui
        ];
        mode = "mutable";
      };

      # defaultProfile = "nix-tui";
      defaultProfile = config.programs.dsh.profiles.web.materializedName;
    };
  });
}
