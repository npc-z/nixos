{
  hyprland,
  pkgs,
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
      xwayland.enable = true;
    };
    waybar = {
      enable = true;
    };
  };
}
