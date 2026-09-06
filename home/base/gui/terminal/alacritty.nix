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
    # https://alacritty.org/config-alacritty.html
    alacritty
  ];

  xdg.configFile.alacritty = linkDir "alacritty/";
}
