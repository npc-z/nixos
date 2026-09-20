{
  lib,
  mylib,
  ...
}: let
  inherit (lib.options) mkOption;
  inherit (lib.types) nullOr str enum submodule;
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

    busId = mkOption {
      type = nullOr (submodule {
        options = {
          amd = mkOption {
            type = nullOr str;
            default = null;
            description = "PCI bus id of the AMD GPU, e.g. \"PCI:6:0:0\"";
          };
          intel = mkOption {
            type = nullOr str;
            default = null;
            description = "PCI bus id of the Intel GPU, e.g. \"PCI:2:0:0\"";
          };
          nvidia = mkOption {
            type = nullOr str;
            default = null;
            description = "PCI bus id of the NVIDIA GPU, e.g. \"PCI:1:0:0\"";
          };
        };
      });
      default = null;
      description = ''
        PCI bus IDs of the GPUs, required for NVIDIA PRIME render offload
        or reverse sync setups. Value format is "PCI:<bus>:<device>:<function>"
      '';
    };
  };
}
