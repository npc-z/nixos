{
  mylib,
  myvars,
  ...
}: {
  imports =
    (mylib.scanPaths ./.)
    ++ [
      ../base/core
      ../base/tui
      ../base/gui

      ../base/home.nix
    ];

  home.homeDirectory = "/Users/${myvars.username}";

  # enable management of XDG base directories on macOS.
  xdg.enable = true;
}
