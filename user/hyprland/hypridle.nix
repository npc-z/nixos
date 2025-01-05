{
  config,
  lib,
  hostname,
  ...
}: let
  mins_3 = 180;
  mins_30 = 1800;
  mins_10 = 600;

  lock_timeout =
    if hostname == "ser7-nixos"
    then mins_30
    else mins_3;

  dpms_off_timeout =
    if hostname == "ser7-nixos"
    then mins_30
    else mins_10;

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

          lock_cmd = "hyprlock"; # dbus/sysd lock command (loginctl lock-session)
        };

        listener = [
          {
            # Lock screen
            timeout = lock_timeout;
            on-timeout = "loginctl lock-session";
            on-resume = ''notify-send "Welcome back!"'';
          }

          {
            # Turn off Monitors
            timeout = dpms_off_timeout;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
