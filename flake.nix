{
  description = "npc's NixOS Flake";

  # the nixConfig here only affects the flake itself, not the system configuration!
  nixConfig = {
    abort-on-warn = true;
    # extra-substituters will be appended to the default substituters when fetching packages
    extra-substituters = [
      # llm-agents
      "https://cache.numtide.com" # Nix packages for AI coding agents and development tools
      # noctalia
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      # llm-agents
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" # Nix packages for AI coding agents and development tools
      # noctalia
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

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

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Nix packages for AI coding agents and development tools
    llm-agents.url = "github:numtide/llm-agents.nix";
    # manage skills
    skills-catalog.url = "path:./agent-skills";

    # hyprland env
    # Community scripts and utilities for Hypr projects
    hyprland-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # scrollable workspace overview plugin, like niri
    hyprland-scroll-overview = {
      # git+https to avoid GitHub API rate limits when resolving HEAD
      url = "git+https://github.com/yayuuu/hyprland-scroll-overview";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # niri
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix"; # the cachix branch always points to the latest cached commit
      # inputs.nixpkgs.follows = "nixpkgs"; # To use the binary cache, you have to omit inputs.nixpkgs.follows
    };

    tix.url = "github:JRMurr/tix";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions/master";

    # 万象拼音 (personal fork)，作为 fcitx5-rime 的共享 rime 数据
    # git+https to avoid GitHub API rate limits when resolving HEAD
    rime-wanxiang = {
      url = "git+https://github.com/npc-z/rime-wanxiang";
      flake = false;
    };
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
