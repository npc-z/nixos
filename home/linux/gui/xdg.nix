{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  xdg.configFile."mimeapps.list".source = link "xdg/mimeapps.list";
}
