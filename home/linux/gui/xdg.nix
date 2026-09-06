{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;
in {
  xdg.configFile."mimeapps.list" = linkFile "xdg/mimeapps.list";
}
