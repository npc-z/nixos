{
  inputs,
  pkgs,
  ...
}: {
  # 使用 home manage 配置也需要开启 zsh
  programs.zsh.enable = true;

  programs = {
    # direnv = {
    #   enable = true;
    #   silent = true;
    # };
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    # waybar = {
    #   enable = true;
    # };
  };
}
