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
