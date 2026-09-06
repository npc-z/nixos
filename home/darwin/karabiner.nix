{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;
in {
  xdg.configFile."karabiner/karabiner.json" = linkFile "karabiner/karabiner.json";
}
