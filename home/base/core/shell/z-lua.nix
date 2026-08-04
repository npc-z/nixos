{...}: {
  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [
      "enhanced"
      "once"
      "fzf"
    ];
  };
}
