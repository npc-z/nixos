{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.sparkle
  ];

  # 不给 GUI 授权：只给 Sparkle 托管的 mihomo 内核授权，
  # 它才是创建 TUN / 改路由所需 CAP_NET_ADMIN 的进程。
  # NOTE: Sparkle → 内核 → 选择「使用系统内核」。
  security.wrappers.mihomo = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin,cap_net_raw=+ep";
    source = lib.getExe pkgs.mihomo;
  };

  # networking.proxy.default = "http://127.0.0.1:20171";

  networking.firewall.trustedInterfaces = ["mihomo"];
}
