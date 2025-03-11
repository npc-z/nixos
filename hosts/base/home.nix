{
  config,
  pkgs,
  settings,
  ...
}: {
  # 注意修改这里的用户名与用户目录
  home.username = "${settings.user.username}";
  home.homeDirectory = "/home/${settings.user.username}";

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  xdg = {
    enable = true;

    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";

    mimeApps = {
      enable = true;
      # /etc/profiles/per-user/npc/share/applications
      # /run/current-system/sw/share/applications
      defaultApplications = let
        browser = ["firefox.desktop" "microsoft-edge.desktop"];
        editor = ["nvim.desktop" "code.desktop"];
      in {
        "application/json" = browser;
        "application/pdf" = "org.kde.okular.desktop";

        "text/plain" = editor;
        "text/html" = browser;
        "text/xml" = browser;

        "application/xml" = browser;
        "application/xhtml+xml" = browser;
        "application/xhtml_xml" = browser;
        "application/rdf+xml" = browser;
        "application/rss+xml" = browser;
        "application/x-extension-htm" = browser;
        "application/x-extension-html" = browser;
        "application/x-extension-shtml" = browser;
        "application/x-extension-xht" = browser;
        "application/x-extension-xhtml" = browser;
        "application/x-wine-extension-ini" = editor;

        "x-scheme-handler/about" = browser; # open `about:` url with `browser`
        "x-scheme-handler/ftp" = browser; # open `ftp:` url with `browser`
        "x-scheme-handler/http" = browser;
        "x-scheme-handler/https" = browser;

        "audio/*" = ["mpv.desktop"];
        "video/*" = ["mpv.desktop"];

        "image/*" = ["imv-dir.desktop"];
        "image/gif" = ["imv-dir.desktop"];
        "image/jpeg" = ["imv-dir.desktop"];
        "image/png" = ["imv-dir.desktop"];
        "image/webp" = ["imv-dir.desktop"];

        "x-scheme-handler/vscode" = ["code-url-handler.desktop"]; # open `vscode://` url with `code-url-handler.desktop`
        "x-scheme-handler/tg" = ["org.telegram.desktop.desktop "];
      };
    };
  };

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
    ./../../home/base/git.nix
    ./../../home/base/shell
    ./../../home/base/tools

    ./../../user/fcitx5
    ./../../user/neovim
    ./../../user/vscode
    ./../../user/theme
    ./../../user/hyprland

    ./../../user/appimage
  ];

  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置

  #  home.file.".config/waybar/scripts" = {
  #    source = ./../../dotfiles/waybar/.config/waybar/scripts;
  #    recursive = true; # 递归整个文件夹
  #    executable = true; # 将其中所有文件添加「执行」权限
  #  };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';
  #  home.file.".config/waybar/config".source = ./../../dotfiles/waybar/.config/waybar/config;
  #  home.file.".config/waybar/style.css".source = ./../../dotfiles/waybar/.config/waybar/style.css;

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

    # terminal
    alacritty
    kitty
    foot

    # file manager
    nautilus
    # terminal file manager
    yazi
    # xfce.thunar

    # pdf viewer
    libsForQt5.okular
    zathura

    flameshot
    rustdesk-flutter

    # web browser
    microsoft-edge
    firefox

    # editor

    # Day/night gamma adjustments for Wayland
    wlsunset

    # GUI for mapping keyboard and mouse controls to a gamepad
    # note: 只支持有线连接(Xbox 🎮)
    antimicrox

    # music
    # Small and simple sound and music player
    amberol

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

  programs = {
    # alacritty.enable = true;
    # https://www.reddit.com/r/NixOS/comments/191j6ta/programswaybarenable_spawns_waybar_twice_after/
    waybar.enable = true;
  };

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
