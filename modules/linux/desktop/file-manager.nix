{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nautilus
  ];

  # GVfs, a userspace virtual filesystem
  # 它的核心作用就是：让各种“非本地”的资源，在用户看来就像电脑里的普通文件夹和文件一样，可以进行无缝的操作
  services.gvfs.enable = true;

  # Sushi, a quick previewer for nautilus
  services.gnome.sushi.enable = true;

  programs.nautilus-open-any-terminal = {
    # Whether to enable nautilus-open-any-terminal
    enable = true;
    terminal = "kitty";
  };
}
