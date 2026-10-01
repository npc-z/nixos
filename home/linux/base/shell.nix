{...}: {
  home.sessionVariables = {
    # set default applications
    # EDITOR = "nvim";
    # VISUAL = "nvim";
    # BROWSER = "microsoft-edge";
    TERMINAL = "kitty";

    # enable scrolling in git diff
    DELTA_PAGER = "less -R";

    # MANPAGER = "sh -c 'col -bx | bat -l man -p'";

    HF_HOME = "$HOME/.cache/huggingface";
    HF_HUB_ENABLE_HF_TRANSFER = "1";
    TRANSFORMERS_CACHE = "$HOME/.cache/huggingface";
  };
}
