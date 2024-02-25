{pkgs, ...}: let
  basic_sh = ./../dotfiles/shell/basic.sh;
  fzf_zsh = ./../dotfiles/shell/fzf.zsh;
  zinit_sh = ./../dotfiles/shell/zinit.sh;
in {
  environment.systemPackages = with pkgs; [
    zsh
    z-lua
    fzf-zsh
    zsh-fzf-tab
    bat # A cat(1) clone with syntax highlighting and Git integration
    zinit # zsh plugin mamanger
  ];
  programs = {
    zsh = {
      enable = true;
      # z - jump around
      # source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
      # export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      # export ZSH_THEME="lambda"
      # plugins=(git)
      # source $ZSH/oh-my-zsh.sh
      interactiveShellInit = ''
        source ${basic_sh}
        source ${fzf_zsh}

        # z-lua 初始化
        eval "$(z.lua  --init zsh)"

        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

        source "${pkgs.zinit}/share/zinit/zinit.zsh"
        source ${zinit_sh}
      '';
      shellAliases = {
        "vim" = "nvim";
        "cls" = "clear";
        "gs" = "git st";
        "ga" = "git add .";
        "gco" = "git co";
        "gl" = "git lg";
        "gac" = ''git add . && git commit -m "update $(date "+%Y-%m-%d %H:%M:%S")"'';
        "gacp" = "gac && git push";
        "gpl" = "git pull";
        "gps" = "git push";
        "lg" = "lazygit";
        ll = "eza -1 --icons=auto --color-scale-mode=gradient --color=auto -l";
        ls = "eza --icons=auto --color-scale-mode=gradient --color=auto";
      };
      autosuggestions = {
        enable = true;
      };
      ohMyZsh = {
        enable = true;
        theme = "amuse";
        plugins = [
          # "git"
        ];
      };
    };

    # A command-line fuzzy finder
    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
  };
}
