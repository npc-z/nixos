{
  config,
  lib,
  ...
}: let
  cfg = config.modules.laptop;
in {
  # https://nixos.wiki/wiki/Laptop
  config = lib.mkIf cfg.enable {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };
}
