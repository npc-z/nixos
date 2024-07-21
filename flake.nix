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
      url = "github:hyprwm/Hyprland/v0.40.0";
      # or
      # url = "github:hyprwm/Hyprland";
    };

    hyprland-plugins = {
      # https://github.com/hyprwm/hyprland-plugins/issues/178
      # match hyprland v0.40.0
      # url = "github:hyprwm/hyprland-plugins/dcbdc9a";
      # not work well for hyprbars
      url = "github:hyprwm/hyprland-plugins/fd133914bf1921db2a26627698f914478f6a9471";
      inputs.hyprland.follows = "hyprland";
    };

    # hyprland-easymotion = {
    #   url = "github:DreamMaoMao/hyprland-easymotion";
    #   inputs.hyprland.follows = "hyprland";
    # };

    # hycov = {
    #   url = "github:DreamMaoMao/hycov";
    #   inputs.hyprland.follows = "hyprland";
    # };
    #
    hyprscroller = {
      # work with hyprland v0.40.0
      url = "github:dawsers/hyprscroller/5f3d0d7848afc581dda4ab20c7edb12e2e82d208";
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
