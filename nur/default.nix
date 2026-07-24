{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    # 启用 nur
    inputs.nur.modules.nixos.default
  ];

  # https://github.com/nix-community/NUR
  # https://nur.nix-community.org/
  environment.systemPackages = [
    # NOTE: 依赖 qtwebengine-5.15.19, 但是需要自己 build
    # pkgs.nur.repos.xddxdd.netease-cloud-music
    # pkgs.nur.repos.Freed-Wu.netease-cloud-music # failed to build, not work now
    pkgs.nur.repos.mic92.hello-nur
    pkgs.nur.repos.xddxdd.baidunetdisk
  ];
}
