{pkgs, ...}: {
  home.packages = with pkgs; [
    # database tool
    dbeaver-bin
  ];
}
