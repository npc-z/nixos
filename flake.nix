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

    # 添加 NUR 仓库
    nur.url = "github:nix-community/NUR";
    # 强制 NUR 和该 flake 使用相同版本的 nixpkgs
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  # 引入 nixos-cn flake 作为 inputs
  inputs.nixos-cn = {
    url = "github:nixos-cn/flakes";
    # 强制 nixos-cn 和该 flake 使用相同版本的 nixpkgs
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-cn,
    nur,
    ...
  } @ inputs: {
    nixosConfigurations = {
      "ser7-nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ser7/configuration.nix

          # 引入定义了 overlays 的 Module
          (import ./overlays)

          (import ./nixoscn-apps/default.nix {nixos-cn = nixos-cn;})

          # 启用 NUR
          nur.nixosModules.nur
          (import ./nur)

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.npc = import ./hosts/ser7/home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };

      #
      "r9000p-nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/r9000p/configuration.nix

          # 引入定义了 overlays 的 Module
          (import ./overlays)

          (import ./nixoscn-apps/default.nix {nixos-cn = nixos-cn;})

          # 启用 NUR
          nur.nixosModules.nur
          (import ./nur)

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.npc = import ./hosts/r9000p/home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };
    };
  };
}
