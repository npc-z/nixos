{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;
in {
  home.file.".ssh/config" = linkFile "ssh/config";
}
