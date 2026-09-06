{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  xdg.configFile.wallpapers = {
    source = link "wallpapers/";
    recursive = true;
  };
}
