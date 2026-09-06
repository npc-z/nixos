{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  home.packages = with pkgs; [
    kitty
  ];

  xdg.configFile.kitty = {
    source = link "kitty/";
    recursive = true;
  };
}
