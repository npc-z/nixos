{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      # for niri
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk

      # for hyprland
      xdg-desktop-portal-hyprland
    ];

    config.common.default = "*";

    config.Hyprland = {
      default = [
        "hyprland"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = ["hyprland"];
      "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
    };

    # FIXME:
    # Cannot use screen sharing in feishu with niri
    # https://github.com/YaLTeR/niri/issues/2254
    # 下面方案 feishu 只能成功共享一次，退出后再共享失败，并且 osb 无法使用
    # https://github.com/YaLTeR/niri/issues/2254#issuecomment-3614986318
    config.niri = {
      default = [
        "gtk"
        "gnome"
      ];
      "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
    };
  };
}
