{...}: {
  programs = {
    clash-verge = {
      # package = pkgs.clash-nyanpasu;
      enable = true;
      # autoStart = true;
      tunMode = true;
      serviceMode = true;
    };
  };

  networking = {
    firewall = {
      # Traffic coming in from these interfaces will be accepted unconditionally
      # 启用 tun 模式之后可通过 `ip a` 查看接口名称
      trustedInterfaces = [
        "Meta" # new in r9000p
        "Mihomo" # new in ser7
        "mihomo" # old
      ];
    };
  };
}
