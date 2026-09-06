{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkDir;
in {
  xdg.configFile.scripts = linkDir "scripts/";
}
