{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  home-manager,
  nixos-cn,
  nur,
  ...
}: let
  _system = "x86_64-linux";
  _home-manager = home-manager;

  pkgs-stable = import nixpkgs-stable {
    inherit inputs;
    system = _system;
    config.allowUnfree = true;
  };

  # 是否启用模块
  moduleEnableSettings = {
    nur = true;
    nixoscn = true;
  };

  userSettings = {
    username = "npc";
    git = {
      userName = "npc-z";
      userEmail = "1763998996@qq.com";
    };
  };

  systemSettings = {};

  _specialArgs = {
    inherit pkgs-stable;
    inherit nixpkgs;
    inherit nixpkgs-stable;
    inherit home-manager;
    inherit nixos-cn;
    inherit nur;
    inherit moduleEnableSettings;
    inherit userSettings;
    inherit systemSettings;
  };

  osTemplate = {
    hostDir,
    system ? _system,
    specialArgs ? _specialArgs,
    home-manager ? _home-manager,
    ...
  }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      inherit specialArgs;

      modules = [
        # 基础配置
        ./base/configuration.nix

        # 导入主机的配置
        ./${hostDir}/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.npc = import ./${hostDir}/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };
in {
  # mini host
  "ser7-nixos" = osTemplate {hostDir = "ser7";};

  # laptop
  "r9000p-nixos" = osTemplate {hostDir = "r9000p";};

  # work
  "thinkpad-e14-nixos" = osTemplate {hostDir = "thinkpad-e14";};

  #
  "start-nixos" = nixpkgs.lib.nixosSystem {
    system = _system;
    specialArgs = _specialArgs;

    modules = [
      # 基础配置
      ./base
      ./hosts/start/start.nix
    ];
  };
}
