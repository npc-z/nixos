{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.obs;
in {
  options.modules.obs = {
    enable = mkEnableOption "obs-studio";

    # NVENC 编码器要 cudaSupport 才会带上 autoAddDriverRunpath，否则
    # obs-nvenc 无法 dlopen libnvidia-encode.so.1（nixpkgs#383402）
    nvenc = mkEnableOption "NVIDIA NVENC hardware encoding in obs-studio";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      enable = true;
      package = mkIf cfg.nvenc (pkgs.obs-studio.override {cudaSupport = true;});
      plugins = [
        pkgs.obs-bilibili-stream
      ];
    };
  };
}
