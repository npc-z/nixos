{
  config,
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
  xdg.configFile.wallpapers = {
    source = mkSymlink "${dotfilesRoot}/wallpapers/";
    recursive = true;
  };
}
