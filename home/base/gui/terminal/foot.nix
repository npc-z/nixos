{
  config,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkDir;
in {
  # foot is designed only for Linux
  home.packages = with pkgs;
    if stdenv.hostPlatform.isLinux
    then [
      foot
    ]
    else [];

  xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    foot = linkDir "foot/";
  };
}
