{
  config,
  myvars,
  mylib,
  pkgs,
  ...
}: {
  # 注意修改这里的用户名与用户目录
  home.username = "${myvars.username}";
  home.homeDirectory = "/home/${myvars.username}";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # Mason works if you enable .local/bin
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # add environment variables
  home.sessionVariables = {
    # set default applications
    # EDITOR = "nvim";
    # VISUAL = "nvim";
    # BROWSER = "microsoft-edge";
    TERMINAL = "foot";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
  };

  # programs
  imports = [
    (mylib.relativeToRoot "home/base")
    (mylib.relativeToRoot "home/linux/base")
    (mylib.relativeToRoot "home/linux/gui")
  ];

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  # xresources.properties = {
  #     "Xcursor.size" = 16;
  #     "Xft.dpi" = 172;
  # };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs; [
    # make dev env
    # devbox
    devenv
    cargo

    # mitschemeX11
    telegram-desktop
    swaynotificationcenter

    eudic

    # pdf viewer
    # libsForQt5.okular
    zathura
    netease-cloud-music-gtk
    # Console-based Audio Visualizer for Alsa
    cava

    rustdesk-flutter

    # Day/night gamma adjustments for Wayland
    wlsunset

    # GUI for mapping keyboard and mouse controls to a gamepad
    # note: 只支持有线连接(Xbox 🎮)
    antimicrox

    # music
    # Beautiful, fast, fluent, light weight music player written in GTK4
    gapless

    # ocr
    (pkgs.writeShellApplication {
      name = "ocr";
      runtimeInputs = with pkgs; [tesseract grim slurp coreutils];
      text = ''
        echo "Generating a random ID..."
        id=$(tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w 6 | head -n 1 || true)
        echo "Image ID: $id"

        echo "Taking screenshot..."
        grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr-"$id".png

        echo "Running OCR..."
        tesseract /tmp/ocr-"$id".png - -l eng+chi_sim | wl-copy
        echo -en "File saved to /tmp/ocr-'$id'.png\n"


        echo "Sending notification..."
        notify-send "OCR " "Text copied!"

        echo "Cleaning up..."
        rm /tmp/ocr-"$id".png -vf
      '';
    })
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
