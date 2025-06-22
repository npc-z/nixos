{pkgs, ...}: {
  programs = {
    # clash-verge = {
    #   package = pkgs.clash-nyanpasu;
    #   enable = true;
    #   autoStart = true;
    # };
  };

  environment.systemPackages = with pkgs; [
    # FIXME: 暂时失去网络连接时，内存泄露
    # https://github.com/v2fly/v2ray-core/issues/3167
    # v2raya

    # clash-meta
    # metacubexd
    # clash-nyanpasu
    clash-verge-rev
  ];
  # services.v2raya.enable = true;
  # services.mihomo.webui = pkgs.metacubexd;

  systemd.services.clash-verge-rev = {
    enable = true;
    description = "clash verge rev";
    serviceConfig = {
      ExecStart = "${pkgs.clash-verge-rev}/bin/clash-verge-service";
    };
    wantedBy = ["multi-user.target"];
  };

  # FIXME: 失去网络连接时，内存泄露
  # https://github.com/v2fly/v2ray-core/issues/3167
  # auto restart or stop v2raya.service when network status changed
  systemd.services.network-monitor = {
    enable = false;
    # Packages added to the service’s PATH environment variable
    path = [
      "/run/current-system/sw"
    ];

    # enable = false;
    description = "Network monitor for v2raya service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      ExecStart = "${pkgs.writeShellScript "network-monitor" ''
        #!/run/current-system/sw/bin/bash

        SERVICE_NAME="v2raya.service"

        while true; do
          sleep 3s

          if nmcli -t -f CONNECTIVITY general | grep -q "full"; then
            # echo "网络已连接"
            if ! systemctl is-active --quiet "$SERVICE_NAME"; then
              echo "重新连接网络， $SERVICE_NAME 服务未启动，正在启动服务..."
              systemctl restart "$SERVICE_NAME"
              echo "$SERVICE_NAME 服务已启动"
            # else
            #   echo "$SERVICE_NAME 服务已在运行"
            fi
          else
            # echo "网络未连接"
            if systemctl is-active --quiet "$SERVICE_NAME"; then
              echo "网络已断开，$SERVICE_NAME 服务已启动，正在关闭服务..."
              systemctl stop "$SERVICE_NAME"
              echo "$SERVICE_NAME 服务已关闭"
            # else
            #   echo "$SERVICE_NAME 服务已关闭"
            fi
          fi
        done
      ''}";
    };
  };
}
