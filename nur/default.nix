{
  config,
  inputs,
  ...
}: {
  imports = [
    # 启用 nur
    inputs.nur.nixosModules.nur
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # 提示这个版本的 ssl 不安全，此时临时信任
    "openssl-1.1.1w"

    # electron-11.5.0 is marked as insecure, refusing to evaluate
    "electron-11.5.0"
  ];

  # https://github.com/nix-community/NUR
  # https://nur.nix-community.org/
  environment.systemPackages = [
    # 只能最小化退出, 仍旧使用 nixos-cn 版本
    config.nur.repos.xddxdd.netease-cloud-music
    config.nur.repos.mic92.hello-nur
    config.nur.repos.xddxdd.baidunetdisk
  ];
}
