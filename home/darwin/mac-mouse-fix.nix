{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  home.file."Library/Application Support/com.nuebling.mac-mouse-fix/config.plist".source =
    link "mac-mouse-fix/config.plist";
}
