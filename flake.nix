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
    nur = {
      url = "github:nix-community/NUR";
      # 强制 NUR 和该 flake 使用相同版本的 nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 引入 nixos-cn flake 作为 inputs
    nixos-cn = {
      url = "github:nixos-cn/flakes";
      # 强制 nixos-cn 和该 flake 使用相同版本的 nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 远程部署
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    nixos-cn,
    nur,
    deploy-rs,
    ...
  } @ inputs: {
    nixosConfigurations = (
      import ./hosts {
        inherit inputs;
        inherit nixpkgs;
        inherit nixpkgs-stable;
        inherit home-manager;
        inherit nixos-cn;
        inherit nur;
      }
    );

    # 远程部署
    deploy = import ./deploy.nix {
      sshUser = "root";
      user = "root";
      inherit deploy-rs;
      inherit self;
    };
  };
}
