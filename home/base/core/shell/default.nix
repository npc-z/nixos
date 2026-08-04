{
  config,
  mylib,
  pkgs,
  ...
}: let
  networkFunc = builtins.readFile ./scripts/network.sh;
  fzfCfg = builtins.readFile ./scripts/fzf.zsh;

  shellAliases = {
    public_ip = let
      # api = "https://ipinfo.io/json"; # 备用 API
      api = "http://ip-api.com/json?lang=zh-CN";
    in ''curl -s "${api}" | jq'';

    # ##########################################
    # git alias
    # ##########################################
    gs = "git status";

    # log
    # gl = "git lg";
    gl = "git lg | head -n 10";
    gl1 = "git lg | head -n 10";
    gl2 = "git lg | head -n 20";
    gl3 = "git lg | head -n 30";
    gl4 = "git lg | head -n 40";
    gl5 = "git lg | head -n 50";
    glf = "git lg | grep"; # git log filter

    # diff
    gd = "git diff";
    gds = "git diff --staged";

    # branc
    gco = "git checkout";
    gcod = "git checkout feature/dev";
    gcot = "git checkout feature/test";
    gm = "git merge";
    gr = "git rebase";
    gpl = "git pull";
    gps = "git push";
    gfa = "git fetch --all";

    ga = "git add .";
    gac = "git add . && git commit -m \"update $(date \"+%Y-%m-%d %H:%M:%S\")\"";
    gcm = "git commit -m ";
    gacp = "gac && git push";

    # git stash
    gss = "git add . && git stash save";
    gsl = "git stash list --relative-date";
    gsa = "git stash apply ";

    lg = "lazygit";

    # ##########################################
    # other alias
    # ##########################################

    cat = "bat --plain";

    # shortcut
    cls = "clear";
    sz = "source ~/.config/zsh/.zshrc && echo source .zshrc done";
    vz = "vim ~/.config/zsh/.zshrc";
    j = "just";

    # format python files in git repo
    # 对新文件执行 isort and black, 对旧文件执行 darker
    gfmtpy = ''git status -s | awk '$1 != "M" {print $2}' | xargs -r isort && git status -s | awk '$1 != "M" {print $2}' | xargs -r black && git status -s | awk '$1 ~ /^M/ {print $2}' | xargs -r darker'';

    vi = "vim";
    vim = "nvim";
  };
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

  # only works in bash/zsh, not nushell
  home.shellAliases = shellAliases;

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
    enableFishIntegration = true;
    options = [
      "--alias"
      "fuck"
    ];
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    historyWidget.command = ""; # 和 atuin Ctrl-R binding 冲突了
  };

  programs.z-lua = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
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
