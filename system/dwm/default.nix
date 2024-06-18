{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.dwm
    # pkgs.git
    # pkgs.libev
    # pkgs.cmake
    #
    # pkgs.pcre2
    pkgs.picom
    pkgs.xorg.xinit
    pkgs.xorg.xauth
  ];

  services.xserver.windowManager.dwm.enable = true;
  services.xserver.windowManager.dwm.package = pkgs.dwm;
  services.picom.enable = true;
}
