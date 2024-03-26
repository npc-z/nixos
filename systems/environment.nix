{pkgs, ...}: {
  environment.variables.EDITOR = "vim";

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

    # TODO 以下两行尝试解决不能弹出 dialog(没能解决)
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    polkit
    swaynotificationcenter

    wayland-protocols
    wayland-utils
    # =====

    lsof
    fd
    ripgrep
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
    devbox
    docker
    kubectl
    minikube
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
    kitty
    foot
    alacritty
    thefuck
    cinnamon.nemo
    glow
    imv # view image
    mpv # view video
    tldr
    eza
    zathura
    # netease-cloud-music-gtk
    playerctl

    neofetch
    btop
    keyd
    stow
    # desktop
    microsoft-edge
    swaybg
    wofi
    wlogout
    pamixer
    brightnessctl
    #
    brightnessctl
    pamixer
    networkmanagerapplet
    v2raya
    # (pkgs.callPackage ./../nur/osdlyrics/default.nix {})
  ];
}
