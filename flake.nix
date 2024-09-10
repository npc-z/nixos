{
  description = "npc's NixOS Flake";

  inputs = {
    # Official NixOS package source, using nixos's unstable branch by default
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    # home-manager，用于管理用户配置
    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 添加 NUR 仓库
    nur.url = "github:nix-community/NUR";

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

    # 当然也可以直接依赖本地的 git 仓库
    dwm.url = "github:npc-z/dwm";
    # dwm.url = "git+file:/home/npc/github/dwm?shallow=1";
    # picom.url = "git+file:/home/npc/github/picom?shallow=1";
    # picom.url = "github:yshui/picom";

    # mydwm
    # dwm.url = "git+file:/home/npc/mydwm?shallow=1";
    # picom.url = "github:DreamMaoMao/mypicom";

    # hyprland env
    hyprland = {
      # NOTE: hyprscroller 更新到 unstable 之后，再切换到 pkgs 版本
      # 使用这种方式引入不能启动
      # just for hyprscroller follows
      # v0.42.0
      url = "git+https://github.com/hyprwm/Hyprland/?rev=9a09eac79b85c846e3a865a9078a3f8ff65a9259&submodules=1";
    };

    # Community scripts and utilities for Hypr projects
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland-plugins = {
    #   # https://github.com/hyprwm/hyprland-plugins/issues/178
    #   # match hyprland v0.40.0
    #   # url = "github:hyprwm/hyprland-plugins/dcbdc9a";
    #   # not work well for hyprbars
    #   url = "github:hyprwm/hyprland-plugins/fd133914bf1921db2a26627698f914478f6a9471";
    #   inputs.hyprland.follows = "hyprland";
    # };

    # hyprland-easymotion = {
    #   url = "github:DreamMaoMao/hyprland-easymotion";
    #   inputs.hyprland.follows = "hyprland";
    # };

    # hycov = {
    #   url = "github:DreamMaoMao/hycov";
    #   inputs.hyprland.follows = "hyprland";
    # };

    hyprscroller = {
      url = "github:dawsers/hyprscroller/5fe29fcbd7103782d55cfb50482c64c31189f02a";
      inputs.hyprland.follows = "hyprland";
    };

    # Hyprspace = {
    #   url = "github:KZDKM/Hyprspace";
    #   inputs.hyprland.follows = "hyprland";
    # };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    ...
  } @ inputs: {
    nixosConfigurations = (
      import ./hosts {
        inherit inputs;
        inherit nixpkgs;
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
