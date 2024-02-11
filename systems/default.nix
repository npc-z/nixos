{...}: {
  imports = [
    ./fonts.nix
    ./il8n.nix
    # ./fcitx5
    ./boot.nix
    ./networking.nix
    ./user.nix
    ./hardware.nix
    ./nix-conf.nix
    ./services.nix
    ./programs.nix
    ./security.nix
    ./environment.nix
  ];
}
