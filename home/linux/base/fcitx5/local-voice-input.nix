{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf types;
  cfg = config.modules.fcitx5.vinput;

  vinputPackages = inputs.fcitx5-vinput.packages."${pkgs.stdenv.hostPlatform.system}";
  # 同源同版本，只差本地 sherpa-onnx 离线识别：完整版带本地推理，lite 纯云端（见 lite 选项）
  fcitx5-vinput =
    if cfg.lite
    then vinputPackages.fcitx5-vinput-lite
    else vinputPackages.default;
in {
  options.modules.fcitx5.vinput = {
    # 关闭时 addon、D-Bus 激活文件（随包提供）与 systemd unit 一起移除。
    enable = mkEnableOption "vinput voice input";

    autostart = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to start vinput-daemon at login (Install.WantedBy=default.target).

        Only effective when enable = true. When disabled the daemon is started
        on demand through its D-Bus activation file, or manually with
        `systemctl --user start vinput-daemon`.
      '';
    };

    lite = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Use the lite build of fcitx5-vinput instead of the full one.

        Both are the same upstream version; the lite build is compiled with
        VINPUT_ENABLE_LOCAL_ASR=OFF and drops everything that depends on the
        sherpa-onnx/onnxruntime stack:

        - local offline ASR (sherpa-onnx backends, VAD, the bundled
          silero_vad.onnx and libsherpa-onnx-*.so, hotwords)
        - the `model` and `hotword` CLI subcommands and the GUI hotword page
        - about 200 MiB of closure (onnxruntime, openvino, onetbb, protobuf)

        Cloud ASR providers and LLM post-processing are unaffected, and the
        binaries, D-Bus name, addon and systemd unit keep the same names, so
        the two builds are interchangeable. Note that upstream's default
        config selects the local sherpa-onnx provider, which the lite build
        rejects at runtime, so a lite host needs a cloud provider configured.
      '';
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      fcitx5-vinput
    ];

    # 列表型 option，会与 default.nix 里的基础 addon 列表合并
    i18n.inputMethod.fcitx5.addons = [
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
      Install = mkIf cfg.autostart {
        WantedBy = ["default.target"];
      };
    };
  };
}
