{pkgs, ...}: {
  home.packages = with pkgs; [
    # https://alacritty.org/config-alacritty.html
    alacritty
  ];
}
