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

    # electron-11.5.0 is marked as insecure, refusing to evaluate
    "electron-11.5.0"
  ];

  # https://github.com/nix-community/NUR
  # https://nur.nix-community.org/
  environment.systemPackages = [
    # pkgs.nur.repos.xddxdd.netease-cloud-music # failed to build, not work now
    pkgs.nur.repos.Freed-Wu.netease-cloud-music
    pkgs.nur.repos.mic92.hello-nur
    pkgs.nur.repos.xddxdd.baidunetdisk
  ];
}
