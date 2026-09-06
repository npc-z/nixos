{pkgs, ...}: {
  home.packages = with pkgs; [
    # clipboard
    wl-clipboard
    clipse

    # GUI for mapping keyboard and mouse controls to a gamepad
    # note: 只支持有线连接(Xbox 🎮)
    antimicrox
  ];

  home.sessionVariables = {
    # force Qt/Chromium/Electron apps to use the Wayland (Ozone) backend
    NIXOS_OZONE_WL = "1";
    # preferred editor
    EDITOR = "nvim";
  };
}
