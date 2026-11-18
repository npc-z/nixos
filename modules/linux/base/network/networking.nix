{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # 开启热点
    # Set Linux as router in one command. Support Internet sharing, redsocks, Wifi hotspot, IPv6.
    # NOTE: 创建离线热点
    # sudo lnxrouter -n --ap wlp2s0 MyAP -p '12345678' --freq-band 2.4 -c 6 --no-virt
    linux-router

    networkmanagerapplet
    iw # Tool to use nl80211
    connect # Make network connection via SOCKS and https proxy
  ];

  networking = {
    networkmanager = {
      enable = true;
      # 只作为“公网 DNS 入口”，让 TUN 开启时查询能进入 mihomo 的 dns-hijack。
      # DHCP 的校园 DNS 仍保留为后备。
      insertNameservers = ["223.5.5.5"];
    };

    extraHosts = ''
      # 140.82.113.4	github.com
      # 185.199.108.133 raw.githubusercontent.com
      # 185.199.109.133 raw.githubusercontent.com
      # 185.199.110.133 raw.githubusercontent.com
      # 185.199.111.133 raw.githubusercontent.com
      # 20.201.28.151 github.com
      # 20.205.243.166 github.com
      # 20.87.245.0 github.com
      # 20.248.137.48 github.com
      # 20.207.73.82 github.com
      # 20.27.177.113 github.com
      # 20.200.245.247 github.com
      # 20.175.192.147 github.com
      # 20.233.83.145 github.com
      # 20.29.134.23 github.com
      # 20.201.28.152 github.com
      # 20.205.243.160 github.com
      # 20.87.245.4 github.com
      # 20.248.137.50 github.com
      # 20.207.73.83 github.com
      # 20.27.177.118 github.com
      # 20.200.245.248 github.com
      # 20.175.192.146 github.com
      # 20.233.83.149 github.com
      # 20.29.134.19 github.com
    '';
  };
}
