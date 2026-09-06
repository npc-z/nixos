{pkgs, ...}: {
  home.packages = with pkgs; [
    # pdf viewer
    zathura

    # English dictionary
    eudic

    # office suite
    # wpsoffice # cant build
    libreoffice-qt-stable

    # Modern, feature-rich ebook reader
    # https://github.com/readest/readest
    readest
  ];
}
