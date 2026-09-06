{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  xdg.configFile."karabiner/karabiner.json".source = link "karabiner/karabiner.json";
}
