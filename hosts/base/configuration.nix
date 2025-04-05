{...}: {
  imports = [
    # 引入定义了 overlays 的 Module
    ./../../overlays
    # nur
    ./../../nur

    # system

    ./../../system/environment.nix
    ./../../system/media.nix

    ./../../system/hardware.nix
    ./../../system/networking.nix
    ./../../system/programs.nix
    ./../../system/services.nix
    ./../../system/user.nix
    ./../../system/nix-ld.nix
    ./../../system/swaylock.nix
  ];

  system.stateVersion = "24.05"; # Did you read the comment?
}
