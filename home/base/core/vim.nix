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
  home.file.".vimrc".source = mkSymlink "${dotfilesRoot}/vim/.vimrc";
}
