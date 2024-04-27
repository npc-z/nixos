{
  hyprland,
  pkgs,
  system,
  ...
}: {
  programs = {
    direnv = {
      enable = true;
      silent = true;
    };
    hyprland = {
      enable = true;
      package = hyprland.packages.${pkgs.system}.hyprland;
    };
    waybar = {
      enable = true;
    };
  };
}
