{pkgs, ...}: {
  home.packages = with pkgs; [
    # English dictionary
    eudic

    # pdf viewer
    zathura

    # remote desktop software
    rustdesk-flutter

    # Day/night gamma adjustments for Wayland
    wlsunset

    # GUI for mapping keyboard and mouse controls to a gamepad
    # note: 只支持有线连接(Xbox 🎮)
    antimicrox
  ];
}
