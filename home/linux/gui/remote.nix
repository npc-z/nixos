{pkgs, ...}: {
  home.packages = with pkgs; [
    # remote desktop software
    rustdesk-flutter

    # local network file sharing
    localsend
  ];
}
