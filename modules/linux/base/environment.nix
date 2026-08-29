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

  environment.systemPackages = with pkgs; [
    gcc
    cmake

    polkit
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

    # wpsoffice # cant build
    libreoffice-qt-stable

    # common tools
    vim
    wl-clipboard
    clipse
    # tools

    glow
    imv # view image
    mpv # view video
    vlc # Cross-platform media player and streaming server

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
