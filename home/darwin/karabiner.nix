{
  config,
  myvars,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtDarwin + "/dotfiles";
in {
  xdg.configFile."karabiner/karabiner.json".source = mkSymlink "${dotfilesRoot}/karabiner/karabiner.json";
}
