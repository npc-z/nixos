{
  lib,
  mylib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr enum;
in {
  imports = mylib.scanPaths ./.;

  options.modules.gpu = {
    type = mkOption {
      type = nullOr (enum ["pi" "amd" "intel" "nvidia" "hybrid-nv" "hybrid-amd"]);
      default = null;
      description = ''
        The manifaturer/type of the primary system GPU. Allows the correct GPU
        drivers to be loaded, potentially optimizing video output performance
      '';
    };
  };
}
