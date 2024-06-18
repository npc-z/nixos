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
    nur = {
      url = "github:nix-community/NUR";
      # 强制 NUR 和该 flake 使用相同版本的 nixpkgs
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    # dwm.url = "git+file:/home/npc/github/dwm?shallow=1";
    # picom.url = "github:yaocccc/picom";

    # hyprland env
    hyprland = {
      url = "github:hyprwm/Hyprland/v0.40.0";
      # or
      # url = "github:hyprwm/Hyprland";
    };

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
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
    #
    # hyprscroller = {
    #   url = "github:dawsers/hyprscroller";
    #   inputs.hyprland.follows = "hyprland";
    # };

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
