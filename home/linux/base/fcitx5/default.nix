{
  config,
  lib,
  myvars,
  pkgs,
  ...
}: let
  dotfiles = config.lib.file.mkOutOfStoreSymlink "${myvars.thisRepoPathAtNixos}/dotfiles";
  rimeBuildDir = "${config.home.homeDirectory}/.local/share/fcitx5/rime/build";
  rimeStateFile = "${config.home.homeDirectory}/.local/state/fcitx5-rime-build-path";
  rimeDataPath = "${pkgs.fcitx5-rime}";
in {
  home.file.".local/share/fcitx5/themes" = {
    recursive = true;
    source = "${dotfiles}/fcitx5/themes";
  };

  # rime 数据（万象拼音 fork + 语法模型）由 overlays/fcitx5 通过 rimeDataPkgs
  # 注入 fcitx5-rime 的共享数据目录，源在 flake.nix 的 inputs.rime-wanxiang

  # librime 只在"源文件比 build 产物新"时才增量重建，而 nix store 文件 mtime 恒为 0，
  # 所以共享数据更新后必须全量部署才能生效。这里在 fcitx5-rime store 路径
  # （随 fork/语法模型变化）改变时自动清除 build/，下次 fcitx5 启动即全量重建。
  home.activation.cleanRimeBuild = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    if [ -f "${rimeStateFile}" ] && [ "$(cat "${rimeStateFile}")" != "${rimeDataPath}" ]; then
      rm -rf "${rimeBuildDir}"
    fi
    mkdir -p "${builtins.dirOf rimeStateFile}"
    echo -n "${rimeDataPath}" > "${rimeStateFile}"
  '';

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

    "fcitx5/conf/rime.conf".source = "${dotfiles}/fcitx5/rime.conf";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      # for flypy chinese input method
      fcitx5-rime
      # needed enable rime using configtool after installed
      qt6Packages.fcitx5-configtool
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk # gtk im module
    ];
  };
}
