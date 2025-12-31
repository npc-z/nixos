{pkgs, ...}: {
  home.packages = with pkgs; [
    microsoft-edge
    firefox
    # google-chrome
  ];
}
