{
  inputs,
  pkgs,
  ...
}: {
  environment.variables.EDITOR = "nvim";

  # MUSIC=...
  # PICTURES=...
  # VIDEOS=...
  # DESKTOP=path/relative/to/home
  # DOWNLOAD=...
  # TEMPLATES=...
  # PUBLICSHARE=...
  environment.etc = {
    "xdg/user-dirs.defaults".text = ''
      DOCUMENTS=/home/npc/Documents"
    '';
  };

  nixpkgs.config.permittedInsecurePackages = [
    # 提示这个版本的 ssl 不安全，此时临时信任
    # 被 wechat-uos 依赖
    "openssl-1.1.1w"
  ];

  environment.systemPackages = with pkgs; [
    python311
    python311Packages.pip
    go
    nodejs_20
    cargo
    gnumake
    gcc9
    cmake
    # lua
    stylua
    lua-language-server

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

    # formatter for nix
    alejandra
    # make dev env
    devenv

    dbeaver-bin
    just # 提供一种保存和运行项目特有命令的便捷方式

    wpsoffice
    # common tools
    git
    lazygit
    delta
    vim
    neovim
    curl
    wget
    jq
    wl-clipboard
    clipse
    # tools
    thefuck
    glow

    tldr
    eza
    zathura
    playerctl
    localsend

    neofetch
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
    inputs.hyprlock.packages.${pkgs.system}.hyprlock
    hypridle
    pamixer
    brightnessctl
    pavucontrol # PulseAudio Volume Control
    #
    networkmanagerapplet
    v2raya
    feishu
    qq
    wechat-uos # need override license, use overlay or use nur version
  ];
}
