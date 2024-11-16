{
  imports = [
    ./base.nix
    ./apps.nix
    # NOTE: dont import homebrew.nix when did not install homebrew manually yet
    ./homebrew.nix
    ./nix-core.nix
    ./system.nix
  ];
}
