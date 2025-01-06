{
  inputs,
  pkgs,
  ...
}: {
  # https://wiki.archlinux.org/title/steam
  # Games installed by Steam works fine on NixOS, no other configuration needed.
  programs.steam = {
    # Some location that should be persistent:
    #   ~/.local/share/Steam - The default Steam install location
    #   ~/.local/share/Steam/steamapps/common - The default Game install location
    #   ~/.steam/root        - A symlink to ~/.local/share/Steam
    #   ~/.steam             - Some Symlinks & user info
    enable = true;
    gamescopeSession = {
      # https://wiki.hyprland.org/0.40.0/Configuring/Performance/#my-games-work-poorly-especially-proton-ones
      enable = true;
      # gamescopeSession = "gamescope";
      # gamescopeSession = "mangohud";
    };
  };

  # misc
  hardware.graphics = {
    # if you also want 32-bit support (e.g for Steam)
    enable32Bit = true;
  };
}
