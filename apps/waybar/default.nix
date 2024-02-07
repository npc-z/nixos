{ config, pkgs, ... }:

{
    home.file.".config/waybar/scripts" = {
        source = ./../../dotfiles/waybar/.config/waybar/scripts;
        recursive = true;   # 递归整个文件夹
        executable = true;  # 将其中所有文件添加「执行」权限
    };
    home.file.".config/waybar/config".source = ./../../dotfiles/waybar/.config/waybar/hyprland/config;
    home.file.".config/waybar/style.css".source = ./../../dotfiles/waybar/.config/waybar/hyprland/style.css;
}
