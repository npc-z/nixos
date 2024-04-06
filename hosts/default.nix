{
  inputs,
  nixpkgs,
  nixpkgs-stable,
  home-manager,
  nixos-cn,
  nur,
  ...
}: let
  system = "x86_64-linux";

  pkgs-stable = import nixpkgs-stable {
    inherit inputs;
    inherit system;
    config.allowUnfree = true;
  };

  specialArgs = {
    inherit pkgs-stable;
    inherit nixpkgs;
    inherit nixpkgs-stable;
    inherit home-manager;
    inherit nixos-cn;
    inherit nur;
  };
in {
  "ser7-nixos" = nixpkgs.lib.nixosSystem {
    inherit system;
    inherit specialArgs;

    modules = [
      ./ser7/configuration.nix

      # 引入定义了 overlays 的 Module
      (import ./../overlays)
      # (import ./overlays)

      ./../nixoscn-apps

      # 启用 NUR
      {nixpkgs.overlays = [nur.overlay];}
      # ./nur

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.npc = import ./ser7/home.nix;
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
  };
}
