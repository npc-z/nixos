{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
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

  xdg.configFile.zathura = {
    source = link "zathura/";
    recursive = true;
  };
}
