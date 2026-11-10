{pkgs, ...}: {
  home.packages = with pkgs; [
    # remote desktop software
    # rustdesk-flutter # FIXME: cant build now

    # local network file sharing
    localsend
  ];
}
