{
  config,
  myvars,
  ...
}: let
  user = myvars.username;
  scriptPath = "/home/npc/.config/scripts/check_disk_health.sh";
in {
  systemd.services.check-disk-health = {
    description = "定时硬盘健康检测服务";
    # Packages added to the service’s PATH environment variable
    path = [
      "/run/current-system/sw"
    ];

    wants = ["network-online.target"];
    after = ["network-online.target"];
    serviceConfig = {
      ExecStart = scriptPath;
      User = user;
      # 保证环境变量正常传递，方便 notify-send 工作
      Environment = [
        "DISPLAY=:0"
        "XDG_RUNTIME_DIR=/run/user/${toString (builtins.getent config.users.users user).uid}"
      ];
      Restart = "on-failure";
      RestartSec = 30;
    };
    wantedBy = ["multi-user.target"];
  };

  systemd.timers.check-disk-health-timer = {
    description = "硬盘健康检测定时器";
    wantedBy = ["timers.target"];
    timerConfig = {
      # 每天早晚8点执行
      OnCalendar = "*-*-* 08,20:00:00";
      Persistent = true; # 如果错过执行，开机后补执行
    };
  };

  # 确保定时器自动启用
  systemd.enable = true;
  systemd.timers = {
    enable = true;
  };

  # 允许普通用户运行 smartctl (如果需要 sudo 权限)
  # 你可以创建 /etc/sudoers.d/smartctl 文件，内容如下：
  # youruser ALL=(ALL) NOPASSWD: /usr/bin/smartctl
  # 并在脚本里调用 sudo smartctl，或直接配置权限访问硬盘设备。
}
