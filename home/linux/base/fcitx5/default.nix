{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;
in {
  imports = mylib.scanPaths ./.;

  config = {
    xdg.configFile = {
      "fcitx5/config" = linkFile "fcitx5/config";
      "fcitx5/profile" =
        linkFile "fcitx5/profile"
        // {
          # NOTE: 下面这个说法有待观察
          # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
          # so we need to force replace it in every rebuild to avoid file conflict.
          force = true;
        };

      "fcitx5/conf/classicui.conf" = linkFile "fcitx5/classicui.conf";
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.waylandFrontend = true;
      fcitx5.addons = with pkgs; [
        # needed enable rime using configtool after installed
        qt6Packages.fcitx5-configtool
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk # gtk im module
      ];
    };
  };
}
