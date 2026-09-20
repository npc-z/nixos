{
  config,
  lib,
  ...
}: final: prev: {
  # 万象拼音词库直接用 nixpkgs 的 rime-wanxiang，它的 $out/share/rime-data 布局
  # 正好符合 rimeDataPkgs 要求。个人 patch 不再打进包里，改放 rime 用户目录，
  # 见 home/linux/base/fcitx5/default.nix。
  # 注意 nixpkgs 把上游 default.yaml 改名为 wanxiang_suggested_default.yaml，
  # 并删掉了 custom/。前者靠用户目录的 default.custom.yaml include 回来；
  # 后者只在运行时切换双拼方案（/flypy 等）时需要，当前方案不依赖。

  # 万象语法模型（RIME-LMDG），不在 git 仓库内，需从 release 下载。
  # 上游会覆盖同名 LTS 资产，模型更新时需同步更新 sha256：
  #   nix-prefetch-url https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram
  wanxiang-grammar-model =
    final.runCommand "wanxiang-grammar-model" {
      src = final.fetchurl {
        url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
        sha256 = "sha256-muS3vo5FWBGBJKf7BQl9tqNBPVFamLFKvQK4ogddBUI=";
      };
    } ''
      mkdir -p $out/share/rime-data
      cp $src $out/share/rime-data/wanxiang-lts-zh-hans.gram
    '';

  # 将万象数据与语法模型作为共享 rime 数据编译进 fcitx5-rime。
  # rimeDataPkgs 默认只有 rime-data，所以这个 override 必须保留。
  fcitx5-rime = prev.fcitx5-rime.override {
    rimeDataPkgs =
      [final.rime-wanxiang]
      ++ lib.optionals config.modules.fcitx5.rime.grammarModel.enable [
        final.wanxiang-grammar-model
      ];
  };
}
