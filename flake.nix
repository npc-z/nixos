{
  description = "npc's NixOS Flake";

  inputs = {
    # NixOS 官方软件源，这里使用 nixos-23.11 分支
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager，用于管理用户配置
    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "ser7-nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ser7/configuration.nix

          # 添加如下内嵌 module 定义
          #   这里将 modules 的所有参数 args 都传递到了 overlays 中
          # (args: {nixpkgs.overlays = import ./overlays args;})

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.npc = import ./hosts/ser7/home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
  };
}
