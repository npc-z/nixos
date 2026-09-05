{pkgs, ...}: {
  # XDG desktop portal 配置统一放系统层 (/etc/xdg/xdg-desktop-portal/)，
  # daemon 会监视该目录并在配置变更后热加载；
  # 若放 Home Manager (~/.config/xdg-desktop-portal/)，daemon 只在启动时读取，
  # 改配置后必须手动重启 portal 服务才生效。
  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      # FileChooser 由 gtk 后端提供，screencast/screenshot 按会话路由
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      # for hyprland
      xdg-desktop-portal-hyprland
    ];

    # 兜底：桌面未知或未匹配到具体会话配置时，文件选择走 gtk
    config.common = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
    };

    config.hyprland = {
      default = [
        "hyprland"
        "gtk"
      ];
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      "org.freedesktop.impl.portal.ScreenCast" = ["hyprland"];
      "org.freedesktop.impl.portal.Screenshot" = ["hyprland"];
    };

    config.niri = {
      default = [
        "gtk"
        "gnome"
      ];
      # gnome 后端在非 GNOME 会话只暴露 settings，FileChooser 必须显式走 gtk
      "org.freedesktop.impl.portal.FileChooser" = ["gtk"];

      # FIXME:
      # Cannot use screen sharing in feishu with niri
      # https://github.com/YaLTeR/niri/issues/2254
      "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
      "org.freedesktop.impl.portal.Screenshot" = ["gnome"];
    };
  };
}
