{
  description = "npc's NixOS Flake";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    abort-on-warn = true;
    # Query the mirror of USTC first, and then the official cache.
    substituters = [
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://cache.nixos.org"
    ];

    # substituers will be appended to the default substituters when fetching packages
    extra-substituters = [
      # llm-agents
      "https://cache.numtide.com" # Nix packages for AI coding agents and development tools
    ];
    extra-trusted-public-keys = [
      # llm-agents
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" # Nix packages for AI coding agents and development tools
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    # home-manager，用于管理用户配置
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    darwin-nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "darwin-nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # 添加 NUR 仓库
    nur.url = "github:nix-community/NUR";

    mcp-nixos.url = "github:utensils/mcp-nixos";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix packages for AI coding agents and development tools
    llm-agents.url = "github:numtide/llm-agents.nix";

    # hyprland env
    # Community scripts and utilities for Hypr projects
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    tix.url = "github:JRMurr/tix";
  };

  outputs = {
    self,
    nixpkgs,
    darwin-nixpkgs,
    ...
  } @ inputs: {
    # nixos hosts
    nixosConfigurations = (import ./hosts {inherit inputs nixpkgs;}).nixosConfigurations;

    # darwin hosts
    darwinConfigurations =
      (import ./hosts {
        inputs = inputs;
        nixpkgs = darwin-nixpkgs;
      }).darwinConfigurations;
  };
}
