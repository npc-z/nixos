{
    description = "npc's NixOS Flake";

    inputs = {
        # NixOS 官方软件源，这里使用 nixos-23.11 分支
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

        # home-manager，用于管理用户配置
        home-manager = {
            url = "github:nix-community/home-manager/release-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs: {
        nixosConfigurations = {
            "nixos" = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [
                    ./configuration.nix

                    home-manager.nixosModules.home-manager
                    {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.npc = import ./home.nix;
                    # home-manager.extraSpecialArgs = inputs;
                    }
                ];
            };
        };
    };
}
