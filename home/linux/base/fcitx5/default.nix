{
  config,
  inputs,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkDir linkFile;
  cfg = config.modules.fcitx5.vinput;
  rimeBuildDir = "${config.home.homeDirectory}/.local/share/fcitx5/rime/build";
  rimeStateFile = "${config.home.homeDirectory}/.local/state/fcitx5-rime-build-path";
  rimeDataPath = "${pkgs.fcitx5-rime}";

  # 完整版（默认）：
  fcitx5-vinput = inputs.fcitx5-vinput.packages."${pkgs.stdenv.hostPlatform.system}".default;
  # 或者极简 Lite 版（纯云端 ASR + LLM，零 ONNX 运行时依赖）：
  # fcitx5-vinput = inputs.fcitx5-vinput.packages."${pkgs.stdenv.hostPlatform.system}".fcitx5-vinput-lite;
in {
  options.modules.fcitx5.vinput = {
    # 关闭时 addon、D-Bus 激活文件（随包提供）与 systemd unit 一起移除。
    enable = lib.mkEnableOption "vinput voice input";

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to start vinput-daemon at login (Install.WantedBy=default.target).

        Only effective when enable = true. When disabled the daemon is started
        on demand through its D-Bus activation file, or manually with
        `systemctl --user start vinput-daemon`.
      '';
    };
  };

  config = lib.mkMerge [
    {
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

        "fcitx5/conf/rime.conf" = linkFile "fcitx5/rime.conf";
      };

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons =
          (with pkgs; [
            # for flypy chinese input method
            fcitx5-rime
            # needed enable rime using configtool after installed
            qt6Packages.fcitx5-configtool
            qt6Packages.fcitx5-chinese-addons
            fcitx5-gtk # gtk im module
          ])
          # 语音输入
          ++ lib.optionals cfg.enable [fcitx5-vinput];
      };
    }

    # vinput 语音输入：addon、D-Bus 激活文件（由包自带）与 systemd unit 一起开关
    (lib.mkIf cfg.enable {
      home.packages = [
        fcitx5-vinput
      ];

      systemd.user.services.vinput-daemon = {
        Unit = {
          Description = "Vinput Voice Input Daemon";
          After = ["pipewire.service"];
        };

        Service = {
          Type = "dbus";
          BusName = "org.fcitx.Vinput";
          ExecStart = "${fcitx5-vinput}/bin/vinput-daemon";
        };

        # 默认不设 Install.WantedBy：登录时不自启，仅安装 unit，由 D-Bus 按需拉起。
        # 需要常驻的主机在 home.nix 里设 modules.fcitx5.vinput.autostart = true。
        Install = lib.mkIf cfg.autostart {
          WantedBy = ["default.target"];
        };
      };
    })
  ];
}
