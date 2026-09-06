{
  config,
  myvars,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtNixos + "/dotfiles";
in {
  xdg.configFile."mimeapps.list".source = mkSymlink "${dotfilesRoot}/xdg/mimeapps.list";
}
