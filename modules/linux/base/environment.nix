{
  inputs,
  pkgs,
  ...
}: {
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.variables = {
    EDITOR = "nvim";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  nixpkgs.config.permittedInsecurePackages = [
    # 提示这个版本的 ssl 不安全，此时临时信任
    # 被 wechat-uos 依赖
    "openssl-1.1.1w"
    # electron-11.5.0 is marked as insecure, refusing to evaluate
    "electron-11.5.0"
  ];

  environment.systemPackages = with pkgs; [
    gcc
    cmake

    polkit
    swaynotificationcenter
    libnotify # notify-send
    xdg-user-dirs

    lsof
    fd
    ripgrep
    udisks
    udiskie
    usbutils
    killall

    # 截图
    grim
    slurp
    swappy # Wayland native snapshot editing tool

    dbeaver-bin

    # wpsoffice # cant build
    libreoffice-qt6-fresh

    # common tools
    vim
    wl-clipboard
    clipse
    # tools

    glow
    imv # view image
    mpv # view video
    vlc # Cross-platform media player and streaming server
    obs-studio # Free and open source software for video recording and live streaming

    tldr
    eza
    # shows the type of files
    file

    playerctl
    localsend

    htop
    btop
    cron
    nethogs
    keyd
    stow
    # desktop
    swaybg
    wofi
    wlogout
    pamixer
    brightnessctl
    pavucontrol # PulseAudio Volume Control
    # email
    thunderbird

    feishu
    qq
    wechat-uos
    # wechat # pr: https://github.com/NixOS/nixpkgs/pull/474257
    wemeet
  ];

  # 使用 home manage 配置也需要开启 zsh
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  programs = {
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      xwayland.enable = true;
    };
  };
}
