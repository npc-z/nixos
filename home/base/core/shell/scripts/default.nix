{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  xdg.configFile.scripts = {
    source = link "scripts/";
    recursive = true;
  };
}
