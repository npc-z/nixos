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

  shellAliases = {
    public_ip = "curl ipinfo.io --silent | jq";

    # ##########################################
    # git alias
    # ##########################################
    gs = "git status";
    gm = "git merge";
    gr = "git rebase";
    gl = "git lg";
    gd = "git diff";
    gds = "git diff --staged";
    gco = "git checkout";

    gpl = "git pull";
    gps = "git push";

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

    # shortcut
    cls = "clear";
    sz = "source ~/.zshrc && echo source .zshrc done";
    vz = "vim ~/.zshrc";
    j = "just";

    vi = "vim";
    vim = "nvim";
  };
in {
  imports = mylib.scanPaths ./.;

  home.packages = with pkgs; [
    # A cat(1) clone with syntax highlighting and Git integration
    bat
    thefuck

    # zsh-forgit
    # zsh-fzf-history-search
    fzf
    zsh-fzf-tab
  ];

  # only works in bash/zsh, not nushell
  home.shellAliases = shellAliases;

  programs.thefuck = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
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

      export TERM=xterm-256color
      export PATH="$PATH:${localBin}:${goBin}:${rustBin}"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };

  programs.zsh = {
    enable = true;

    history.append = true;
    history.ignorePatterns = [
      "ls"
      "ll"
      "gs"
      "htop"
      "btop"
    ];

    autosuggestion.enable = true;
    enableCompletion = true;

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

      eval $(thefuck --alias)

      export TERM=xterm-256color
      export PATH="$PATH:${localBin}:${goBin}:${rustBin}"
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };
}
