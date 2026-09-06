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
  home.packages = with pkgs; [
    # https://alacritty.org/config-alacritty.html
    alacritty
  ];

  xdg.configFile.alacritty = {
    source = mkSymlink "${dotfilesRoot}/alacritty/";
    recursive = true;
  };
}
