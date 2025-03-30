{
  inputs,
  nixpkgs,
  ...
}: let
  linux-system = "x86_64-linux";
  darwin-system = "aarch64-darwin";

  inherit (inputs.nixpkgs) lib;
  mylib = import ./../lib {inherit lib;};
  myvars = import ./../vars {};

  specialArgs = {
    inherit inputs;
    inherit myvars;
    inherit mylib;
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
          home-manager.users.${myvars.username} = import ./${hostDir}/home.nix;
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
            user = "${myvars.username}";
          };
        }
      ];
    };
in {
  nixosConfigurations = {
    # mini host
    "ser7-nixos" = osTemplate {
      hostDir = "ser7";
      specialArgs =
        specialArgs
        // {
          hostname = "ser7-nixos";
        };
      system = linux-system;
    };

    # laptop
    "r9000p-nixos" = osTemplate {
      hostDir = "r9000p";
      specialArgs =
        specialArgs
        // {
          hostname = "r9000p-nixos";
        };
      system = linux-system;
    };

    # work
    "thinkpad-e14-nixos" = osTemplate {
      hostDir = "thinkpad-e14";
      specialArgs =
        specialArgs
        // {
          hostname = "thinkpad-e14-nixos";
        };
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
