{
  config,
  lib,
  ...
}: let
  cfg = config.modules.sunshine;
in {
  options.modules.sunshine = {
    enable = lib.mkEnableOption "Sunshine game stream host for Moonlight";
  };

  config = lib.mkIf cfg.enable {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
