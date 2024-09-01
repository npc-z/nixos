{pkgs, ...}: {
  config = {
    # https://nixos.wiki/wiki/Xorg
    environment.variables = {
      GDK_SCALE = "2";
      GDK_DPI_SCALE = "0.5";
      _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    };

    environment.systemPackages = with pkgs; [
      # set background image
      feh

      # Tool to access the X clipboard from a console application
      xclip

      # Window switcher, run dialog and dmenu replacement
      rofi
      # looking lockscreen for linux systems
      # betterlockscreen
      i3lock
      # dunst

      numlockx

      # 电池电量
      acpi

      xorg.xinit
      xorg.xauth
      # X11 itself
      xorg.xorgserver

      # X11 input modules
      xorg.xf86inputevdev
      xorg.xf86inputsynaptics
      xorg.xf86inputlibinput

      # X11 video modules
      xorg.xf86videointel
      xorg.xf86videoati
      xorg.xf86videonouveau
    ];

    services = {
      # Enable touchpad support
      libinput = {
        enable = true;
        touchpad.naturalScrolling = true;
        touchpad.disableWhileTyping = true; # not work
      };

      # FIXME: 使用 displayManager 启动 hyprland 会导致部分程序无法启动
      displayManager.ly.enable = true;

      xserver = {
        enable = true;
        # maybe
        dpi = 180;

        windowManager.hypr.enable = true;
        # startx is treated as a displayManager
        # and therefore it is used instead of the default (lightdm).
        # displayManager.startx.enable = true; # in order to use rustdesk, not support when dwm start in tty
        displayManager.startx.enable = false;

        excludePackages = with pkgs; [
          xterm
        ];
      };
    };
  };
}
