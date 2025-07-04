{pkgs, ...}: {
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  # TODO Fell free to modify this file to fit your needs.
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    btop
    htop
    kitty
    tldr

    cargo
  ];
  environment.variables.EDITOR = "nvim";

  # 使用 home manage 配置也需要开启 zsh
  programs.zsh.enable = true;
}
