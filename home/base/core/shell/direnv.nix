{...}: {
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      # 将项目中的 .direnv 目录放到 .cache 中
      # https://www.reddit.com/r/NixOS/comments/1rb5u9b/comment/o6s4nr9/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
      # SEE https://github.com/direnv/direnv/wiki/Customizing-cache-location
      # NOTE use this to better integrate with tools that poorly recurse the filesystem
      stdlib = ''
        : "''${XDG_CACHE_HOME:="''${HOME}/.cache"}"
        declare -A direnv_layout_dirs
        direnv_layout_dir() {
            local hash path
            echo "''${direnv_layout_dirs[$PWD]:=$(
                hash="''$(sha1sum - <<< "$PWD" | head -c40)"
                path="''${PWD//[^a-zA-Z0-9]/-}"
                echo "''${XDG_CACHE_HOME}/direnv/layouts/''${hash}''${path}"
            )}"
        }
      '';
    };
  };
}
