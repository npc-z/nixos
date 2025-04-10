{...}: {
  imports = [
    # 引入定义了 overlays 的 Module
    ./../../overlays
    # nur
    ./../../nur

    # system

    ./../../system/environment.nix

    ./../../system/programs.nix
    ./../../system/nix-ld.nix
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
