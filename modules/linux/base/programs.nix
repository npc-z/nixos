{...}: {
  programs = {
    # 使用 home manage 配置也需要开启 zsh
    zsh.enable = true;
    nix-ld.enable = true;

    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      xwayland.enable = true;
    };
  };
}
