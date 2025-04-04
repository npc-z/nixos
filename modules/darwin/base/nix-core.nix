{...}: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # do garbage collection weekly to keep disk usage low
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    # NOTE: Disable auto-optimise-store because of this issue:
    # https://github.com/NixOS/nix/issues/7273
    auto-optimise-store = false;
  };
}
