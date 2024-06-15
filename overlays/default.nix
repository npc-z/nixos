{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  nixpkgs.overlays = [
    # When applied, the stable nixpkgs set (declared in the flake inputs) will
    # be accessible through 'pkgs.stable', e.g. `pkgs.stable.cowsay`
    (final: _prev: {
      stable = import inputs.nixpkgs-stable {
        system = final.system;
        config.allowUnfree = true;
      };
    })

    (final: _prev: {
      unstable-feihsu = import inputs.nixpkgs-feishu {
        system = final.system;
        config.allowUnfree = true;
      };
    })

    (import ./weixin)

    # =============================================================
    #                     示例 3 个
    # 参考
    # https://nixos-and-flakes.thiscute.world/zh/nixpkgs/overlays
    # =============================================================

    # =============================================================
    #     overlayer1 - 参数名用 self 与 super，表达继承关系
    # =============================================================

    # Overlay 1 修改了 google-chrome 的 Derivation，增加了一个代理服务器的命令行参数。
    # (self: super: {
    #   google-chrome = super.google-chrome.override {
    #     commandLineArgs = "--proxy-server='https=127.0.0.1:3128;http=127.0.0.1:3128'";
    #   };
    # })

    # =============================================================
    #     overlayer2 - 还可以使用 extend 来继承其他 overlay
    # =============================================================

    # Overlay 2 修改了 steam 的 Derivation，增加了额外的包和环境变量。
    # 这里改用 final 与 prev，表达新旧关系
    # (final: prev: {
    #   steam = prev.steam.override {
    #     extraPkgs = pkgs:
    #       with pkgs; [
    #         keyutils
    #         libkrb5
    #         libpng
    #         libpulseaudio
    #         libvorbis
    #         stdenv.cc.cc.lib
    #         xorg.libXcursor
    #         xorg.libXi
    #         xorg.libXinerama
    #         xorg.libXScrnSaver
    #       ];
    #     extraProfile = "export GDK_SCALE=2";
    #   };
    # })

    # =============================================================
    #       overlay3 - 也可以将 overlay 定义在其他文件中
    # =============================================================

    # 这里 ./overlays/overlay3/default.nix 中的内容格式与上面的一致
    # 都是 `final: prev: { xxx = prev.xxx.override { ... }; }`
    # Overlay 3 被定义在一个单独的文件 ./overlays/overlay3/default.nix 中。
    # (import ./overlay3)
  ];
}
