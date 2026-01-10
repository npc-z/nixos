{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # 启用 nur
    inputs.nur.modules.nixos.default
  ];

  nixpkgs.config.permittedInsecurePackages = [
    # 提示这个版本的 ssl 不安全，此时临时信任
    "openssl-1.1.1w"

    # NOTE: depended by pkgs.nur.repos.xddxdd.netease-cloud-music
    "qtwebengine-5.15.19"
  ];

  # https://github.com/nix-community/NUR
  # https://nur.nix-community.org/
  environment.systemPackages = [
    # NOTE: 依赖 qtwebengine-5.15.19, 但是需要自己 build
    pkgs.nur.repos.xddxdd.netease-cloud-music
    # pkgs.nur.repos.Freed-Wu.netease-cloud-music # failed to build, not work now
    pkgs.nur.repos.mic92.hello-nur
    pkgs.nur.repos.xddxdd.baidunetdisk
  ];
}
