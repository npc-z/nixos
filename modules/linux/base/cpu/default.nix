{
  lib,
  mylib,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) nullOr enum str;
in {
  imports = mylib.scanPaths ./.;

  options.modules.cpu = {
    # the type of cpu your system has - vm and regular cpus currently do not differ
    type = mkOption {
      type = nullOr (enum ["pi" "intel" "vm-intel" "amd" "vm-amd"]);
      default = null;
      description = ''
        The manifaturer/type of the primary system CPU.

        Determines which ucode services will be enabled
        and provides additional kernel packages based on
        the type passed. In case of some vendors, this
        option may also enable additional daemons to
        assist with device health or safety.
      '';
    };

    amd = {
      pstate.enable = mkEnableOption "AMD P-State Driver";
      zenpower = {
        enable = mkEnableOption "AMD Zenpower Driver";
        args = mkOption {
          type = str;
          default = "-p 0 -v 3C -f A0"; # Pstate 0, 1.175 voltage, 4000 clock speed
          description = ''
            The percentage of the maximum clock speed that the CPU will be limited to.

            This is useful for reducing power consumption and heat generation on laptops
            and desktops
          '';
        };
      };
    };
  };

  # config.assertions = [
  #   {
  #     assertion = config.modules.cpu.type != null;
  #     message = ''
  #       ${config.networking.hostName} is missing a cpu type. Please define it
  #       in the appropriate host configuration!
  #     '';
  #   }
  # ];
}
