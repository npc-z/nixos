{
  config,
  lib,
  pkgs,
  myvars,
  ...
}: {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  home.packages = with pkgs; [
    lazygit
  ];

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = myvars.username;
    userEmail = myvars.useremail;

    includes = [
      {
        # use different email & name for work
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }
    ];

    extraConfig = {
      init.defaultBranch = "master";
      # push.autoSetupRemote = true;
      # pull.rebase = true;
      core.editor = "nvim";
      # 正确显示中文文件名
      core.quotepath = false;
    };

    # A syntax-highlighting pager in Rust(2019 ~ Now)
    delta = {
      enable = true;
      options = {
        diff-so-fancy = true;
        line-numbers = true;
        true-color = "always";
        # features => named groups of settings, used to keep related settings organized
        # features = "";
      };
    };

    aliases = {
      br = "branch";

      cm = "commit -m";
      co = "checkout";
      cp = "cherry-pick";

      last = "log -1";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr [%ad]) %C(bold blue)<%an>%Creset' --abbrev-commit --date=format:'%Y-%m-%d %H:%M:%S'";
      llog = "log --graph --name-status --pretty=format:'%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset' --date=relative";

      st = "status";
    };
  };
}
