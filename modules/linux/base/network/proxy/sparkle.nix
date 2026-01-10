{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    pkgs.nur.repos.lonerOrz.sparkle
  ];

  security.wrappers.sparkle = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_bind_service,cap_net_raw,cap_net_admin=+ep";
    source = lib.getExe pkgs.nur.repos.lonerOrz.sparkle;
  };

  networking.proxy.default = "http://127.0.0.1:20171";

  networking.firewall.trustedInterfaces = ["mihomo"];
}
