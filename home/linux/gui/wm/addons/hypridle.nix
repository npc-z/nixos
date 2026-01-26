{
  config,
  lib,
  ...
}: let
  cfg = config.wm.addons.hypridle;
in {
  options.wm.addons.hypridle = {
    enable = lib.mkEnableOption "enable hypridle";

    lock_cmd = lib.mkOption {
      description = "lock command";
      default = "hyprlock";
      example = "hyprlock / swaylock";
      type = lib.types.str;
    };

    lock_timeout = lib.mkOption {
      description = "lock screen timeout in seconds";
      default = 300;
      example = 300;
      type = lib.types.int;
    };

    dpms_off_timeout = lib.mkOption {
      description = "dpms off timeout in seconds";
      default = 600;
      example = 600;
      type = lib.types.int;
    };
  };

  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
          # 例如播放视频时
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false; # whether to ignore systemd-inhibit --what=idle inhibitors

          lock_cmd = cfg.lock_cmd; # dbus/sysd lock command (loginctl lock-session)
        };

        listener = [
          {
            # Lock screen
            timeout = cfg.lock_timeout;
            on-timeout = "loginctl lock-session";
            on-resume = ''notify-send "Welcome back!"'';
          }

          {
            # Turn off Monitors
            timeout = cfg.dpms_off_timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
