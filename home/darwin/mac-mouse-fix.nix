{
  config,
  myvars,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtDarwin + "/dotfiles";
in {
  home.file."Library/Application Support/com.nuebling.mac-mouse-fix/config.plist".source =
    mkSymlink "${dotfilesRoot}/mac-mouse-fix/config.plist";
}
