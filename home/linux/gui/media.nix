{
  config,
  myvars,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtNixos + "/dotfiles";
in {
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

  xdg.configFile = {
    # audio visualizer
    cava = {
      source = mkSymlink "${dotfilesRoot}/cava";
      recursive = true;
    };
    # screenshot annotation editor
    swappy = {
      source = mkSymlink "${dotfilesRoot}/swappy/";
      recursive = true;
    };
  };
}
