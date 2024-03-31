{pkgs, ...}: {
  nixpkgs.config.permittedInsecurePackages = [
    # 提示这个版本的 ssl 不安全，此时临时信任
    # 被 wechat-uos 依赖
    "openssl-1.1.1w"
  ];

  # https://github.com/nix-community/NUR
  # https://nur.nix-community.org/
  environment.systemPackages = with pkgs; [
    nur.repos.xddxdd.wechat-uos
    nur.repos.xddxdd.qq
    nur.repos.xddxdd.netease-cloud-music
  ];
}
