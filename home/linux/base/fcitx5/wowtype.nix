{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.fcitx5.wowtype;
in {
  options.modules.fcitx5.wowtype = {
    enable = mkEnableOption "类微信输入法 wowtype" // {default = true;};
  };

  config = mkIf cfg.enable {
    i18n.inputMethod = {
      fcitx5.addons = [
        inputs.wowtype.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
