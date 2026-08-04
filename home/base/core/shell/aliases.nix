{...}: {
  # only works in bash/zsh, not nushell
  home.shellAliases = {
    public_ip = let
      # api = "https://ipinfo.io/json"; # 备用 API
      api = "http://ip-api.com/json?lang=zh-CN";
    in ''curl -s "${api}" | jq'';

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
}
