{nixos-cn, ...}: {
  # 使用 nixos-cn flake 提供的包
  # TODO trace: warning: `vendorSha256` is deprecated. Use `vendorHash` instead
  environment.systemPackages = [
    nixos-cn.legacyPackages.x86_64-linux.netease-cloud-music
  ];
  # 使用 nixos-cn 的 binary cache
  # nix.settings.trusted-public-keys = [
  #   "https://nixos-cn.cachix.org"
  #   "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
  # ];

  imports = [
    # 将nixos-cn flake提供的registry添加到全局registry列表中
    # 可在`nixos-rebuild switch`之后通过`nix registry list`查看
    # nixos-cn.nixosModules.nixos-cn-registries

    # 引入nixos-cn flake提供的NixOS模块
    # nixos-cn.nixosModules.nixos-cn
  ];
}
