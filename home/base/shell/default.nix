{
  config,
  pkgs,
  ...
}: let
  localBin = "${config.home.homeDirectory}/.local/bin";
  goBin = "${config.home.homeDirectory}/go/bin";
  rustBin = "${config.home.homeDirectory}/.cargo/bin";
  networkFunc = builtins.readFile ./scripts/network.sh;

  shellAliases = {
    public_ip = "curl ipinfo.io --silent | jq";

    # ##########################################
    # git alias
    # ##########################################
    gs = "git status";
    gm = "git merge";
    gr = "git rebase";
    gl = "git lg";
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
  imports = [
    ./starship.nix
    ./direnv.nix
  ];

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
      export PATH="$PATH:${localBin}:${goBin}:${rustBin}"

      export TERM=xterm-256color
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

    initExtra = ''
      ${networkFunc}

      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      eval $(thefuck --alias)

      # =====================
      # fzf-tab common config
      # =====================

      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false

      # set descriptions format to enable group support
      # NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'

      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

      # switch group using `,` and `.`
      zstyle ':fzf-tab:*' switch-group ',' '.'


      # =====================
      #     fzf preview
      # =====================

      # cd
      zstyle ':fzf-tab:complete:(cd|ls|ll):*' fzf-preview 'eza -1 --icons=auto --color-scale-mode=gradient --color=auto -l $realpath'

      # give a preview of commandline arguments when completing `kill`
      zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
        '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
      zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

      # show systemd unit status
      zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

      # show file contents
      # zstyle ':fzf-tab:complete:cat:*' fzf-preview 'bat $realpath'
      zstyle ':fzf-tab:complete:cat:*' fzf-preview '
      case "$(file --mime-type -b $realpath)" in
          text/*) bat --paging=never $realpath ;;
          # image/*) imv $realpath ;; # 图片预览工具（如 imv）
          # application/pdf) pdftotext $realpath - ;; # PDF 转文本预览
          *) echo "Unsupported file type" ;;
      esac
      '


      # environment variable
      zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
        fzf-preview 'echo ''${(P)word}'

      # tldr
      zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color always $word'

      # command
      zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
        '(out=$(tldr --color always "$word") 2>/dev/null && echo $out) || (out=$(MANWIDTH=$FZF_PREVIEW_COLUMNS man "$word") 2>/dev/null && echo $out) || (out=$(which "$word") && echo $out) || echo "''${(P)word}"'

      export TERM=xterm-256color
    '';
  };
}
