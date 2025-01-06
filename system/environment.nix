{
  inputs,
  pkgs,
  ...
}: {
  environment.variables.EDITOR = "nvim";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # MUSIC=...
  # PICTURES=...
  # VIDEOS=...
  # DESKTOP=path/relative/to/home
  # DOWNLOAD=...
  # TEMPLATES=...
  # PUBLICSHARE=...
  # FIXME: environment.etc
  # environment.etc = {
  #   "xdg/user-dirs.defaults".text = ''
  #     DOCUMENTS=/home/npc/Documents
  #   '';
  # };

  nixpkgs.config.permittedInsecurePackages = [
    # 提示这个版本的 ssl 不安全，此时临时信任
    # 被 wechat-uos 依赖
    "openssl-1.1.1w"
    # electron-11.5.0 is marked as insecure, refusing to evaluate
    "electron-11.5.0"
  ];

  environment.systemPackages = with pkgs; [
    python311
    python311Packages.pip
    python311Packages.isort
    python311Packages.black
    gnumake
    gcc9
    cmake
    nixd

    polkit
    swaynotificationcenter
    libnotify # notify-send
    xdg-user-dirs

    lsof
    fd
    ripgrep
    zip
    unzip
    which
    tree
    udisks
    udiskie
    usbutils
    killall

    # 截图
    grim
    slurp
    swappy # Wayland native snapshot editing tool

    dbeaver-bin
    just # 提供一种保存和运行项目特有命令的便捷方式

    wpsoffice
    # common tools
    vim
    curl
    httpie
    wget
    jq
    wl-clipboard
    clipse
    # tools

    glow

    tldr
    eza
    # shows the type of files
    file

    playerctl
    localsend

    fastfetch
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
    hyprlock
    hypridle
    pamixer
    brightnessctl
    pavucontrol # PulseAudio Volume Control
    # email
    thunderbird

    feishu
    qq
    wechat-uos # need override license, use overlay or use nur version

    # libreoffice
    # NOTE: broken in unstable
    # pkgs.stable.rustdesk
  ];
}
