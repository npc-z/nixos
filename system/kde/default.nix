{pkgs, ...}: {
  # https://nixos.wiki/wiki/KDE

  services.xserver.enable = true;
  # For KDE Plasma 6, the defaults have changed.
  # KDE Plasma 6 runs on Wayland with the default session set to plasma.
  # If you want to use the X11 session as your default session, change it to plasmax11.
  # yes, just use the X11
  services.displayManager.defaultSession = "plasmax11";
  services.displayManager.sddm.enable = true;

  # KDE Plasma 6 is now available on unstable
  services.desktopManager.plasma6.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Excluding some KDE Plasma applications from the default install
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole
    oxygen
  ];

  # Using the following example configuration,
  # QT applications will have a look similar to the GNOME desktop, using a dark theme.
  # qt = {
  #   enable = true;
  #   platformTheme = "gnome";
  #   style = "adwaita-dark";
  # };

  programs.dconf.enable = true;
}
