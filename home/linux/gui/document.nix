{
  config,
  myvars,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtNixos + "/dotfiles";
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
    source = mkSymlink "${dotfilesRoot}/zathura/";
    recursive = true;
  };
}
