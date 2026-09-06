{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # development toolchain
    gcc
    cmake

    # system essential utilities
    polkit
    libnotify # notify-send
    xdg-user-dirs

    lsof
    udisks
    udiskie
    usbutils
    killall

    bubblewrap # Unprivileged sandboxing tool

    # system services / daemons
    cron
    nethogs
    keyd

    # desktop audio / backlight
    # pamixer kept system-level: used by root acpid lid-close mute hook
    pamixer
    brightnessctl
  ];
}
