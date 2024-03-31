{pkgs, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    # 提示这个版本的 ssl 不安全，此时临时信任
    # "openssl-1.1.1w"
  ];

  # https://github.com/nix-community/NUR
  # https://nur.nix-community.org/
  environment.systemPackages = with pkgs; [
    # 只能最小化退出, 仍旧使用 nixos-cn 版本
    # nur.repos.xddxdd.netease-cloud-music
  ];
}
