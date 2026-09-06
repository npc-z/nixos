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
    # https://alacritty.org/config-alacritty.html
    alacritty
  ];

  xdg.configFile.alacritty = {
    source = link "alacritty/";
    recursive = true;
  };
}
