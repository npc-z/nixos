{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  sparkleDir = "/home/${myvars.username}/.config/sparkle";

  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;
in {
  # Sparkle seeds its bundled assets from the read-only Nix store into these two
  # runtime directories with the mode preserved (0444 files, 0555 directories),
  # so later in-place updates fail with EACCES. They are the only read-only
  # paths under ~/.config/sparkle, whose own 0700 mode must stay untouched.
  # "Z" recurses, covering nested directories and assets added in the future.
  # tmpfiles cannot set per-type modes on one line ("~" is a no-op on systemd
  # 261), so files also pick up the execute bit.
  systemd.user.tmpfiles.rules =
    # 显式把 Sparkle 配置目录固定为 0700；否则 home-manager 先创建目录时
    # 可能是 0755（订阅链接等敏感信息都在这里）。
    ["d ${sparkleDir} 0700 - - -"]
    ++ map (dir: "Z ${sparkleDir}/${dir} 0755 - - -") [
      "work"
      "test"
    ];

  # 文件里的 tun.dns-mode: disabled 让 sing-tun 不再尝试用 resolvectl 注册
  # 系统 DNS（现在没有 systemd-resolved，注册无意义且会触发 polkit 弹窗）；
  # 真正接管 TUN 下 DNS 的是 tun.dns-hijack: any:53。
  xdg.configFile."sparkle/mihomo.yaml" = (linkFile "sparkle/mihomo.yaml") // {force = true;};
}
