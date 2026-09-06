{
  config,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  repoPath =
    if mylib.isDarwin pkgs
    then myvars.thisRepoPathAtDarwin
    else myvars.thisRepoPathAtNixos;
  dotfilesRoot = repoPath + "/dotfiles";
in {
  # foot is designed only for Linux
  home.packages = with pkgs;
    if stdenv.hostPlatform.isLinux
    then [
      foot
    ]
    else [];

  xdg.configFile = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    foot = {
      source = mkSymlink "${dotfilesRoot}/foot/";
      recursive = true;
    };
  };
}
