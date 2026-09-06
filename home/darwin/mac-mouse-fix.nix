{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;
in {
  home.file."Library/Application Support/com.nuebling.mac-mouse-fix/config.plist" =
    linkFile "mac-mouse-fix/config.plist";
}
