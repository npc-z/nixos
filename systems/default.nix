{...}: {
  imports = [
    ./fonts.nix
    ./il8n.nix
    # ./fcitx5
    ./boot.nix
    ./networking.nix
    ./user.nix
    ./hardware.nix
    ./bluetooth.nix
    ./nix-conf.nix
    ./services.nix
    ./programs.nix
    ./zsh.nix
    ./security.nix
    ./environment.nix
  ];
}
