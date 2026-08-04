{pkgs, ...}: {
  home.packages = with pkgs; [
    zsh-fzf-tab
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    historyWidget.command = ""; # 和 atuin Ctrl-R binding 冲突了
  };
}
