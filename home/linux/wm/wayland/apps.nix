{pkgs, ...}: {
  home.packages = with pkgs; [
    wayland-protocols
    wayland-utils
    # Fusuma is multitouch gesture recognizer
    # fusuma
    libinput-gestures
  ];
}
