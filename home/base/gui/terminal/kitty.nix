{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkDir;
in {
  home.packages = with pkgs; [
    kitty
  ];

  xdg.configFile.kitty = linkDir "kitty/";
}
