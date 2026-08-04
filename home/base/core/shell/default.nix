{
  config,
  mylib,
  pkgs,
  ...
}: let
  networkFunc = builtins.readFile ./scripts/network.sh;
  fzfCfg = builtins.readFile ./scripts/fzf.zsh;
in {
  imports = mylib.scanPaths ./.;

  home.packages = with pkgs; [
    # A cat(1) clone with syntax highlighting and Git integration
    bat
    pay-respects

    # zsh-forgit
    # zsh-fzf-history-search
    zsh-fzf-tab
  ];

  # Mason works if you enable .local/bin
  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    TERM = "xterm-256color";
  };

  # Command suggestions, command-not-found and thefuck replacement written in Rust
  programs.pay-respects = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    options = [
      "--alias"
      "fuck"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    historyWidget.command = ""; # 和 atuin Ctrl-R binding 冲突了
  };

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

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      bind 'set show-all-if-ambiguous on'
      bind 'TAB:menu-complete'

      ${networkFunc}

      eval "$(devenv hook bash)"
    '';
  };

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
