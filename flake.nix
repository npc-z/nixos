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
  } @ inputs: let
    system = "x86_64-linux";

    # 将所有 inputs 参数设为所有子模块的特殊参数，
    # 这样就能直接在子模块中使用 inputs 中的所有依赖项了
    specialArgs = {
      inherit inputs;

      # 将非默认的 nixpkgs 数据源传到其他 modules 中
      # 注意每次 import 都会生成一个新的 nixpkgs 实例
      # 这里我们直接在 flake.nix 中创建实例， 再传递到其他子 modules 中使用
      # 这样能有效重用 nixpkgs 实例，避免 nixpkgs 实例泛滥。
      # 在其他模块中的使用方式，例如
      # {pkgs-stable,...}: {
      #   environment.systemPackages = with pkgs-stable; [
      #     foot
      #   ];
      # }
      pkgs-stable = import nixpkgs-stable {
        # 这里递归引用了外部的 system 属性
        inherit system;
        # 允许安装非自由软件
        config.allowUnfree = true;
      };
    };
  in {
    nixosConfigurations = {
      "ser7-nixos" = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = specialArgs;

        modules = [
          ./hosts/ser7/configuration.nix

          # 引入定义了 overlays 的 Module
          (import ./overlays)

          (import ./nixoscn-apps/default.nix {nixos-cn = nixos-cn;})

          # 启用 NUR
          {nixpkgs.overlays = [nur.overlay];}
          # ./nur

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
        system = "${system}";
        specialArgs = specialArgs;

        modules = [
          ./hosts/r9000p/configuration.nix

          # 引入定义了 overlays 的 Module
          (import ./overlays)

          (import ./nixoscn-apps/default.nix {nixos-cn = nixos-cn;})

          # 启用 NUR
          {nixpkgs.overlays = [nur.overlay];}
          # ./nur

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.npc = import ./hosts/r9000p/home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };

      "thinkpad-e14-nixos" = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = specialArgs;

        modules = [
          ./hosts/thinkpad-e14/configuration.nix

          # 引入定义了 overlays 的 Module
          (import ./overlays)

          (import ./nixoscn-apps/default.nix {nixos-cn = nixos-cn;})

          # 启用 NUR
          {nixpkgs.overlays = [nur.overlay];}
          # ./nur

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.npc = import ./hosts/r9000p/home.nix;
            home-manager.extraSpecialArgs = inputs;
          }
        ];
      };

      #
      "start-nixos" = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = specialArgs;

        modules = [
          # hardware configuration
          ./hosts/r9000p/hardware-configuration.nix
          # basic configuration
          ./hosts/start/start.nix
        ];
      };
    }; #end nixosConfigurations

    # 远程部署
    deploy = {
      sshUser = "root"; # SSH 登录用户名
      user = "root"; # 远程操作的用户
      sshOpts = ["-p" "22"]; # SSH 参数，这里是指定端口 2222

      # 部署失败自动回滚，建议关闭
      # 因为 NixOS（尤其是 Unstable 分支）部署不太稳定，有时需要部署两次才成功
      # 如果自动回滚了，反而适得其反，导致连续部署失败
      autoRollback = false;

      # 断网自动回滚，建议关闭
      # 在你配置防火墙或 IP 出错把网络干掉时，自动回滚，这样你就不用去主机商控制面板连 VNC 或 IPMI 了
      # 但如果你就是在调整防火墙或者 IP 配置，会有当时断网、但重启机器就可以应用新配置恢复正常的情况
      # 自动回滚反而适得其反，因此建议关闭
      magicRollback = false;
      nodes = {
        "r9000p-nixos" = {
          # 目标机器的地址，IP 或域名或 .ssh/config 中配置的别名均可
          hostname = "172.20.10.6";
          profiles.system = {
            # 调用上面的 nixosConfigurations."nixos"
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."r9000p-nixos";
          };
        };
      };
    }; # end deploy-rs
  };
}
