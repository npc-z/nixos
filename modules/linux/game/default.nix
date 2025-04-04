{
  lib,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  options.modules.game = {
    enable = lib.mkEnableOption "game feature";
  };
}
