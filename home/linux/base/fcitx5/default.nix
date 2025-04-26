{
  config,
  myvars,
  pkgs,
  ...
}: let
  dotfiles = config.lib.file.mkOutOfStoreSymlink "${myvars.thisRepoPathAtNixos}/dotfiles";
in {
  home.file.".local/share/fcitx5/themes" = {
    recursive = true;
    source = "${dotfiles}/fcitx5/themes";
  };

  # TODO: manage the rime config
  # mkdir -p ~/.local/share/fcitx5 && cd ~/.local/share/fcitx5 && git clone https://github.com/npc-z/rime-ice.git rime --depth 1

  xdg.configFile = {
    "fcitx5/config".source = "${dotfiles}/fcitx5/config";
    "fcitx5/profile" = {
      source = "${dotfiles}/fcitx5/profile";
      # NOTE: 下面这个说法有待观察
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };

    "fcitx5/conf/classicui.conf".source = "${dotfiles}/fcitx5/classicui.conf";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      # for flypy chinese input method
      fcitx5-rime
      # needed enable rime using configtool after installed
      fcitx5-configtool
      fcitx5-chinese-addons
      fcitx5-gtk # gtk im module
    ];
  };
}
