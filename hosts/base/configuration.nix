{
  lib,
  moduleEnableSettings,
  ...
}: {
  imports =
    [
      # 引入定义了 overlays 的 Module
      ./../../overlays

      # system
      ./../../system/bluetooth.nix
      ./../../system/boot.nix
      ./../../system/environment.nix
      ./../../system/fonts.nix
      ./../../system/hardware.nix
      ./../../system/il8n.nix
      ./../../system/networking.nix
      ./../../system/nix-conf.nix
      ./../../system/programs.nix
      ./../../system/services.nix
      ./../../system/security.nix
      ./../../system/user.nix
      ./../../system/zsh.nix
      ./../../system/nix-ld.nix
    ]
    # 通过 lib.optionals 来决定是否导入（启用）
    ++ (lib.optionals moduleEnableSettings.nur [./../../nur])
    ++ (lib.optionals moduleEnableSettings.nixoscn [./../../nixoscn-apps]);
}
