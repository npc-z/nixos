{
  description = "npc's NixOS Flake";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    abort-on-warn = true;
    # substituters = [
    # Query the mirror of USTC first, and then the official cache.
    # "https://mirrors.ustc.edu.cn/nix-channels/store"
    # "https://cache.nixos.org"
    # ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    # home-manager，用于管理用户配置
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # 添加 NUR 仓库
    nur.url = "github:nix-community/NUR";

    # 远程部署
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland env
    # Community scripts and utilities for Hypr projects
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    deploy-rs,
    ...
  } @ inputs: {
    # nixos hosts
    nixosConfigurations = (import ./hosts {inherit inputs nixpkgs;}).nixosConfigurations;

    # darwin hosts
    darwinConfigurations = (import ./hosts {inherit inputs nixpkgs;}).darwinConfigurations;

    # 远程部署
    deploy = import ./deploy.nix {
      sshUser = "root";
      user = "root";
      inherit deploy-rs;
      inherit self;
    };
  };
}
