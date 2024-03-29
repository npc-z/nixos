{pkgs, ...}: {
  # 注意修改这里的用户名与用户目录
  home.username = "npc";
  home.homeDirectory = "/home/npc";

  # programs
  imports = [
    # ./home/programs/bash
    ./../../apps/bash
    # give up manage waybar config by home-manager
    # ./../../apps/waybar
    ./../../systems/fcitx5
    ./../../systems/vscode
    ./../../systems/theme
    # TODO 放入构建脚本中
    # excute `bash ./dotfiles/config-git.sh `
    # ./../../apps/git
  ];
  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # 设置鼠标指针大小以及字体 DPI（适用于 4K 显示器）
  # xresources.properties = {
  #     "Xcursor.size" = 16;
  #     "Xft.dpi" = 172;
  # };

  # 通过 home.packages 安装一些常用的软件
  # 这些软件将仅在当前用户下可用，不会影响系统级别的配置
  # 建议将所有 GUI 软件，以及与 OS 关系不大的 CLI 软件，都通过 home.packages 安装
  home.packages = with pkgs; [
    mitschemeX11
    telegram-desktop
    swaynotificationcenter
  ];

  # alacritty - 一个跨平台终端，带 GPU 加速功能
  # programs.alacritty = {
  #     enable = true;
  # };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
