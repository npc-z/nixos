{
  config,
  lib,
  pkgs,
  ...
}: {
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

    # TODO 以下两行尝试解决不能弹出 dialog(没能解决)
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    polkit
    wayland-protocols
    wayland-utils
    # =====

    lsof
    fzf-zsh
    fd
    ripgrep
    unzip
    which
    tree
    vscode
    # formatter for nix
    alejandra
    # make dev env
    devbox
    docker
    # common tools
    git
    lazygit
    delta
    vim
    neovim
    curl
    wget
    wl-clipboard
    # tools
    kitty
    foot
    cinnamon.nemo
    glow
    zathura
    netease-cloud-music-gtk
    playerctl

    neofetch
    btop
    zsh
    z-lua
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
  ];
}
