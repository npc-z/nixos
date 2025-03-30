{
  config,
  lib,
  ...
}: let
  cfg = config.hypr.settings;
in {
  config = lib.mkIf cfg.enable {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          # whether to ignore dbus-sent idle-inhibit requests (used by e.g. firefox or steam)
          # 例如播放视频时
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false; # whether to ignore systemd-inhibit --what=idle inhibitors

          lock_cmd = "hyprlock"; # dbus/sysd lock command (loginctl lock-session)
        };

        listener = [
          {
            # Lock screen
            timeout = cfg.hypridle.lock_timeout;
            on-timeout = "loginctl lock-session";
            on-resume = ''notify-send "Welcome back!"'';
          }

          {
            # Turn off Monitors
            timeout = cfg.hypridle.dpms_off_timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
