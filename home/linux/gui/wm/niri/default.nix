{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.wm.niri;

  # FIXME: https://github.com/YaLTeR/niri/issues/1682#issuecomment-2919386619
  # niri 上游生成的 zsh 补全有问题，构建期用 sed 修复后再安装：
  #   - line[2] 索引错误
  #   - 多余的 '::command 分支
  zshCompletion =
    pkgs.runCommand "niri-zsh-completion" {
      nativeBuildInputs = [pkgs.niri];
    } ''
      niri completions zsh | sed "s/line\[2\]/line[1]/g; /'::command/d" > $out
    '';
in {
  options.wm.niri = {
    enable = mkEnableOption "Niri, Scrollable-tiling Wayland compositor";
  };

  imports = [
    ./../addons/hyprlock.nix
    ./../addons/swayidle.nix
    ./../addons/noctalia.nix
    ./../addons/wvkbd.nix

    ./../xdg-portal.nix
  ];

  config = mkIf cfg.enable {
    wm.addons = {
      hyprlock.enable = true;
    };

    home.packages = with pkgs; [
      niri
      xwayland-satellite
      nirius # Utility commands for the niri wayland compositor
    ];

    # 补全只随 niri 模块安装在 Linux host 上，由 zsh 惰性加载
    home.file."${config.xdg.configHome}/zsh/site-functions/_niri".source = zshCompletion;

    # oh-my-zsh 会自行调用 compinit，Home Manager 因此跳过 completionInit，
    # 所以这里在 oh-my-zsh 之前把补全目录加进 fpath
    programs.zsh.initContent = mkOrder 550 ''
      fpath=("${config.xdg.configHome}/zsh/site-functions" $fpath)
    '';
  };
}
