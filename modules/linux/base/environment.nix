{
  inputs,
  pkgs,
  ...
}: {
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

    bubblewrap # Unprivileged sandboxing tool

    # common tools
    vim
    # tools

    glow

    tldr
    eza
    # shows the type of files
    file

    htop
    btop
    cron
    nethogs
    keyd
    stow
    # desktop
    pamixer
    brightnessctl
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
