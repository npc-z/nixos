{ config, lib, pkgs, ... }:

{
    programs = {
        direnv = {
            enable = true;
            silent = true;
        };
        hyprland = {
            enable = true;
        };
        waybar  = {
            enable = true;
        };
        zsh = {
            enable = true;
            # z - jump around
            # source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
            # export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
            # export ZSH_THEME="lambda"
            # plugins=(git)
            # source $ZSH/oh-my-zsh.sh
            interactiveShellInit = ''
                source ~/.config/nixos/dotfiles/shell/basic.sh

                # z-lua 初始化
                eval "$(z.lua  --init zsh)"

                eval "$(direnv hook zsh)"
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
            };
            autosuggestions = {
                enable = true;
            };
            ohMyZsh = {
                enable = true;
                theme = "amuse";
            };
        };
    };
}
