{
  inputs,
  nixpkgs,
  ...
}: let
  system = "x86_64-linux";

  settings = {
    # system variables
    system = {};

    # user variables
    user = {
      username = "npc";
    };

    # 是否启用模块
    module = {
      nixoscn = {
        enable = true;
      };
      nur = {
        enable = true;
      };
    };
  };

  specialArgs = {
    inherit inputs;
    inherit settings;
  };

  osTemplate = {
    hostDir,
    system,
    specialArgs,
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

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.npc = import ./${hostDir}/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.backupFileExtension = "backup";
        }
      ];
    };
in {
  # mini host
  "ser7-nixos" = osTemplate {
    hostDir = "ser7";
    inherit system specialArgs;
  };

  # laptop
  "r9000p-nixos" = osTemplate {
    hostDir = "r9000p";
    inherit system specialArgs;
  };

  # work
  "thinkpad-e14-nixos" = osTemplate {
    hostDir = "thinkpad-e14";
    inherit system specialArgs;
  };

  #
  "start-nixos" = nixpkgs.lib.nixosSystem {
    inherit system;
    inherit specialArgs;

    modules = [
      # 基础配置
      ./base
      ./hosts/start/start.nix
    ];
  };
}
