{
  config,
  mylib,
  pkgs,
  ...
}: let
  localBin = "${config.home.homeDirectory}/.local/bin";
  goBin = "${config.home.homeDirectory}/go/bin";
  rustBin = "${config.home.homeDirectory}/.cargo/bin";
  networkFunc = builtins.readFile ./scripts/network.sh;
  fzfCfg = builtins.readFile ./scripts/fzf.zsh;
  # FIXME: https://github.com/YaLTeR/niri/issues/1682#issuecomment-2919386619
  # niri completions zsh | sed "s/line\[2\]/line[1]/g; /'::command/d" > niri.zsh
  niriCompletions = builtins.readFile ./scripts/niri.zsh;

  shellEnv = ''
    export TERM=xterm-256color
    export PATH="$PATH:${localBin}:${goBin}:${rustBin}"
    export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    # https://opencode.ai/docs/lsp/#built-in
    # disable automatic LSP server downloads
    export OPENCODE_DISABLE_LSP_DOWNLOAD=true

  '';

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
    gl = "git lg";
    glh = "git lg | head -n 30";

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
      ${shellEnv}
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

      ${niriCompletions}

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      ${shellEnv}
    '';
  };
}
