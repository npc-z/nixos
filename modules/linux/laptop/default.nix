{
  lib,
  mylib,
  ...
}: {
  imports = mylib.scanPaths ./.;

  options.modules.laptop = {
    enable = lib.mkEnableOption "laptop feature";
  };
}
