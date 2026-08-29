{
  inputs,
  config,
  lib,
  ...
}: final: prev: {
  # 万象拼音 fork 打成 rimeDataPkgs 需要的 share/rime-data 布局
  rime-wanxiang =
    final.runCommand "npc-rime-wanxiang" {
      src = inputs.rime-wanxiang;
    } ''
      mkdir -p $out/share/rime-data
      cp -r $src/. $out/share/rime-data/
      chmod -R u+w $out/share/rime-data
      # 排除非 rime 数据文件。
      # 注意保留 custom/（/flypy 等运行时切换双拼依赖 shared/custom 里的模板）
      rm -rf $out/share/rime-data/{.git*,.github,docs,README.md,LICENSE,CHANGELOG.md,mkdocs.yml,release-please-config.json,.release-please-manifest.json,version.txt}
    '';

  # 万象语法模型（RIME-LMDG），不在 git 仓库内，需从 release 下载。
  # 上游会覆盖同名 LTS 资产，模型更新时需同步更新 sha256：
  #   nix-prefetch-url https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram
  wanxiang-grammar-model =
    final.runCommand "wanxiang-grammar-model" {
      src = final.fetchurl {
        url = "https://github.com/amzxyz/RIME-LMDG/releases/download/LTS/wanxiang-lts-zh-hans.gram";
        sha256 = "sha256-RVS74bpoPEFuZKsV1lyUR0O9rVJRKFAyaB8S0k7ocQI=";
      };
    } ''
      mkdir -p $out/share/rime-data
      cp $src $out/share/rime-data/wanxiang-lts-zh-hans.gram
    '';

  # 将万象数据与语法模型作为共享 rime 数据编译进 fcitx5-rime
  fcitx5-rime = prev.fcitx5-rime.override {
    rimeDataPkgs =
      [final.rime-wanxiang]
      ++ lib.optionals config.modules.fcitx5.rime.grammarModel.enable [
        final.wanxiang-grammar-model
      ];
  };
}
