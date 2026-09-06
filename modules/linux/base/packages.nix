{pkgs, ...}: {
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
}
