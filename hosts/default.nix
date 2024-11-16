{
  inputs,
  nixpkgs,
  ...
}: let
  linux-system = "x86_64-linux";
  darwin-system = "aarch64-darwin";

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
        {
          nixpkgs.overlays = [
            inputs.dwm.overlays.default
            # inputs.picom.overlays.default
          ];
        }

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

  darwinTemplate = {
    hostDir,
    system,
    specialArgs,
    ...
  }:
    inputs.nix-darwin.lib.darwinSystem {
      inherit system;
      inherit specialArgs;

      modules = [
        {
          nixpkgs.overlays = [
            #
          ];
        }

        # 导入主机的配置
        ./${hostDir}/configuration.nix

        inputs.darwin-home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${settings.user.username} = import ./${hostDir}/home.nix;
          home-manager.extraSpecialArgs = specialArgs;
        }

        # 全新安装时，先注释此处
        inputs.nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            # Apple Silicon Only
            enableRosetta = true;
            # User owning the Homebrew prefix
            user = "${settings.user.username}";
          };
        }
      ];
    };
in {
  nixosConfigurations = {
    # mini host
    "ser7-nixos" = osTemplate {
      hostDir = "ser7";
      inherit specialArgs;
      system = linux-system;
    };

    # laptop
    "r9000p-nixos" = osTemplate {
      hostDir = "r9000p";
      inherit specialArgs;
      system = linux-system;
    };

    # work
    "thinkpad-e14-nixos" = osTemplate {
      hostDir = "thinkpad-e14";
      inherit specialArgs;
      system = linux-system;
    };

    #
    "start-nixos" = nixpkgs.lib.nixosSystem {
      system = linux-system;
      inherit specialArgs;

      modules = [
        # 基础配置
        ./base
        ./hosts/start/start.nix
      ];
    };
  };

  darwinConfigurations = {
    "work-macbook-pro" = darwinTemplate {
      hostDir = "work-macbook-pro";
      inherit specialArgs;
      system = darwin-system;
    };
  };
}
