{pkgs, ...}: {
  home.packages = with pkgs; [
    # remote desktop software
    rustdesk-flutter

    # GUI for mapping keyboard and mouse controls to a gamepad
    # note: 只支持有线连接(Xbox 🎮)
    antimicrox
  ];
}
