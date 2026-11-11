{
  config,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkFile;

  cfg = config.modules.fcitx5.rime;

  rimeBuildDir = "${config.home.homeDirectory}/.local/share/fcitx5/rime/build";
  rimeStateFile = "${config.home.homeDirectory}/.local/state/fcitx5-rime-build-path";
  rimeDataPath = "${pkgs.fcitx5-rime}";
in {
  options.modules.fcitx5.rime = {
    enable = mkEnableOption "fictx5-rime input method";
  };

  config = mkIf cfg.enable {
    home.file = {
      # 万象拼音的共享数据与语法模型由 overlays/fcitx5 通过 rimeDataPkgs 注入
      # fcitx5-rime（nixpkgs 的 rime-wanxiang），个人 patch 只能放用户目录。
      # 用 linkFile 而不是 home.file 默认的 store 链接：librime 只在"源文件比
      # build 产物新"时重建，store 文件 mtime 恒为 0，改 patch 不会生效。
      #
      # default.custom.yaml 是必需的：nixpkgs 把上游 default.yaml 改名为
      # wanxiang_suggested_default.yaml，共享目录里的 default.yaml 是空的，
      # 不 include 回来 schema_list 就为空（没有任何可用方案）。
      ".local/share/fcitx5/rime/wanxiang.custom.yaml" =
        linkFile "fcitx5/rime/wanxiang.custom.yaml";
      ".local/share/fcitx5/rime/default.custom.yaml" =
        linkFile "fcitx5/rime/default.custom.yaml";
    };

    # 部署产物 build/*.yaml 的新旧只按 mtime 判断（librime 的 __build_info/timestamps），
    # 而 store 文件 mtime 恒为 0：nixpkgs 更新 rime-wanxiang / 语法模型 / librime 后内容
    # 变了也不会重建，必须清掉 build/ 才会重新部署。用户目录的两个 patch 是 out-of-store
    # symlink（mtime 真实），librime 自己能发现改动，不依赖这里；这段只兜住 store 侧
    # （共享数据与引擎版本）的变化，故 key 用含 librime 的 fcitx5-rime 路径。
    # 词典 .table.bin/.prism.bin 按内容校验，不受影响。
    home.activation.cleanRimeBuild = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ -f "${rimeStateFile}" ] && [ "$(cat "${rimeStateFile}")" != "${rimeDataPath}" ]; then
        rm -rf "${rimeBuildDir}"
      fi
      mkdir -p "${builtins.dirOf rimeStateFile}"
      echo -n "${rimeDataPath}" > "${rimeStateFile}"
    '';

    xdg.configFile = {
      "fcitx5/conf/rime.conf" = linkFile "fcitx5/rime.conf";
    };

    i18n.inputMethod = {
      fcitx5.addons = with pkgs; [
        fcitx5-rime
      ];
    };
  };
}
