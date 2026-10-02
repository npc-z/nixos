{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkDir;
in {
  programs.noctalia = {
    enable = true;
  };

  xdg.configFile.noctalia = linkDir "noctalia";
}
