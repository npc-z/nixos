{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    imv # view image
    mpv # view video
    vlc # Cross-platform media player and streaming server
    obs-studio # Free and open source software for video recording and live streaming
  ];
}
