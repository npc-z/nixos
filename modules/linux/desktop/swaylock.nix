{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.modules.swaylock;
in {
  options.modules.swaylock = {
    enable = lib.mkEnableOption "Unlock with Swaylock";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [swaylock];

    # Unlock with Swaylock
    security = {
      pam = {
        services = {
          swaylock = {
            fprintAuth = false;
            text = ''
              auth include login
            '';
          };
        };
      };
    };
  };
}
