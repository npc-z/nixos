{pkgs, ...}: {
  home.packages = with pkgs; [
    # -------- media player --------
    # video player
    mpv
    # Cross-platform media player and streaming server
    vlc

    # music
    # Beautiful, fast, fluent, light weight music player written in GTK4
    # gapless
    # netease-cloud-music-gtk
    # Simple Netease Cloud Music player
    nur.repos.ccicnce113424.splayer-next

    # -------- playback / audio control --------
    # media control (play/pause/next/prev)
    playerctl
    # PulseAudio Volume Control
    pavucontrol

    # -------- audio visualizer --------
    # Console-based Audio Visualizer for Alsa
    cava

    # -------- image viewer --------
    imv # view image

    # -------- screenshot --------
    grim
    slurp
    swappy # Wayland native snapshot editing tool
  ];
}
