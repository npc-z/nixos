{
  config,
  myvars,
  pkgs,
  ...
}: {
  home.packages = [
    # https://docs.noctalia.dev/getting-started/faq/#why-are-some-of-my-app-icons-missing
    pkgs.qt6Packages.qt6ct # for icon theme
  ];

  xdg.configFile = let
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    repoPath = myvars.thisRepoPathAtNixos;
    dotfilesRoot = repoPath + "/dotfiles";
  in {
    "qt6ct/qt6ct.conf".source = mkSymlink "${dotfilesRoot}/qt6ct/qt6ct.conf";
  };

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  qt = {
    enable = true;
    # platformTheme.name = "adwaita";
    # style.name = "adwaita-dark";
  };

  gtk = {
    enable = true;
    gtk4.theme = null;
    theme = {
      package = pkgs.whitesur-gtk-theme;
      name = "WhiteSur-Light";
    };

    # iconTheme = {
    #   package = pkgs.adwaita-icon-theme;
    #   name = "Adwaita";
    # };

    iconTheme = {
      name = "Tela-pink";
      package = pkgs.tela-icon-theme;
    };

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 14;
    };
  };
}
