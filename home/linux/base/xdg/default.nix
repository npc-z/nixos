{
  config,
  myvars,
  ...
}: let
  dotfiles = config.lib.file.mkOutOfStoreSymlink "${myvars.thisRepoPathAtNixos}/dotfiles";
in {
  # 递归将某个文件夹中的文件，链接到 Home 目录下的指定位置

  #  home.file.".config/waybar/scripts" = {
  #    source = ./../../dotfiles/waybar/.config/waybar/scripts;
  #    recursive = true; # 递归整个文件夹
  #    executable = true; # 将其中所有文件添加「执行」权限
  #  };

  # 直接以 text 的方式，在 nix 配置文件中硬编码文件内容
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  #  home.file.".config/waybar/config".source = ./../../dotfiles/waybar/.config/waybar/config;
  #  home.file.".config/waybar/style.css".source = ./../../dotfiles/waybar/.config/waybar/style.css;

  # Managing mutable files in NixOS
  # https://www.foodogsquared.one/posts/2023-03-24-managing-mutable-files-in-nixos/
  home.file = {
    ".config/mimeapps.list" = {
      # recursive = true;
      source = "${dotfiles}/xdg/mimeapps.list";
      # 这种形式的链接后的文件只可读不可写
      # source = config.lib.file.mkOutOfStoreSymlink (lib.path.append ../. "dotfiles/xyz");
    };
  };
}
