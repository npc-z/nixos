{pkgs, ...}: let
  basic_sh = ./../dotfiles/shell/basic.sh;
  fzf_zsh = ./../dotfiles/shell/fzf.zsh;
in {
  environment.systemPackages = with pkgs; [
    zsh
    z-lua
    fzf-zsh
    zsh-fzf-tab
    bat # A cat(1) clone with syntax highlighting and Git integration
    # zinit # zsh plugin mamanger
  ];
  programs = {
    # A command-line fuzzy finder
    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };

    zsh = {
      enable = true;
      interactiveShellInit = ''
        source ${basic_sh}

        # z-lua 初始化
        eval "$(z.lua  --init zsh enhanced once fzf)"

        source ${fzf_zsh}
        source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

        # export NIX_LD=$(nix eval --impure --raw --expr 'let pkgs = import <nixpkgs> {}; NIX_LD = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"; in NIX_LD')

        # https://wiki.hyprland.org/0.40.0/Configuring/Uncommon-tips--tricks/#minimize-steam-instead-of-killing
        # if [ "$(hyprctl activewindow -j | jq -r ".class")" = "Steam" ]; then
        #     xdotool getactivewindow windowunmap
        # else
        #     hyprctl dispatch killactive ""
        # fi
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
  };
}
