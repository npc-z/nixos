{ config, pkgs, ... }:

{
    programs.bash = {
        enable = true;
        enableCompletion = true;
        # 在这里添加你的自定义 bashrc 内容
        bashrcExtra = ''
            export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"

            source ~/.config/nixos/dotfiles/shell/basic.sh
        '';

        # 设置一些别名方便使用，你可以根据自己的需要进行增删
        shellAliases = {
            urldecode = "python -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
            urlencode = "python -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
        };
    };
}

