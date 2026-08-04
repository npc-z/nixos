{
  config,
  pkgs,
  ...
}: let
  networkFunc = builtins.readFile ./scripts/network.sh;
  fzfCfg = builtins.readFile ./scripts/fzf.zsh;
in {
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    history.append = true;
    history.ignorePatterns = [
      "ls"
      "ll"
      "gs"
      "htop"
      "btop"
    ];

    enableCompletion = true;
    autosuggestion = {
      enable = true;
      strategy = [
        "completion"
        "history"
      ];
    };

    oh-my-zsh = {
      enable = true;
      theme = "amuse";
      plugins = [
        # "git"
      ];
    };

    initContent = ''
      ${networkFunc}

      ${fzfCfg}

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      eval "$(devenv hook zsh)"
    '';
  };
}
