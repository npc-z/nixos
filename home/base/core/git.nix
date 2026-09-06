{
  config,
  lib,
  mylib,
  pkgs,
  myvars,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  # `programs.git` will generate the config file: ~/.config/git/config
  # to make git use this config file, `~/.gitconfig` should not exist!
  #
  #    https://git-scm.com/docs/git-config#Documentation/git-config.txt---global
  home.activation.removeExistingGitconfig = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    rm -f ${config.home.homeDirectory}/.gitconfig
  '';

  home.packages = with pkgs; [
    lazygit
    gh
  ];

  # only works in bash/zsh, not nushell
  home.shellAliases = {
    gs = "git status";

    # log
    # gl = "git lg";
    gl = "git lg | head -n 10";
    gl1 = "git lg | head -n 10";
    gl2 = "git lg | head -n 20";
    gl3 = "git lg | head -n 30";
    gl4 = "git lg | head -n 40";
    gl5 = "git lg | head -n 50";
    glf = "git lg | grep"; # git log filter

    # diff
    gd = "git diff";
    gds = "git diff --staged";

    # branch
    gco = "git checkout";
    gcod = "git checkout feature/dev";
    gcot = "git checkout feature/test";
    gm = "git merge";
    gr = "git rebase";
    gpl = "git pull";
    gps = "git push";
    gfa = "git fetch --all";

    ga = "git add .";
    gac = "git add . && git commit -m \"update $(date \"+%Y-%m-%d %H:%M:%S\")\"";
    gcm = "git commit -m ";
    gacp = "gac && git push";

    # git stash
    gss = "git add . && git stash save";
    gsl = "git stash list --relative-date";
    gsa = "git stash apply ";

    lg = "lazygit";
  };

  # programs.gh.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    signing.format = null;

    includes = [
      {
        # use different email & name for work
        path = "~/work/.gitconfig";
        condition = "gitdir:~/work/";
      }
    ];

    settings = {
      user = {
        name = myvars.gitUserName;
        email = myvars.useremail;
      };
      init.defaultBranch = "master";

      core = {
        editor = "nvim";
        quotepath = false; # 正确显示中文文件名
      };

      push = {
        autoSetupRemote = true; # easier to push new branchs
        default = "current"; # push only current branch by ddefault
        followTags = true; # push also tags
      };

      pull = {
        rebase = true;
        default = "current";
      };

      rebase = {
        autoStash = true;
        missingCommitsCheck = "warn"; # warn if rebasing with missing commits
      };

      branch = {
        sort = "-committerdate";
      };

      tag = {
        sort = "-taggerdate";
      };

      iteractive = {
        singleKey = true;
      };

      alias = {
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
  };

  # A syntax-highlighting pager in Rust(2019 ~ Now)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      diff-so-fancy = true;
      line-numbers = true;
      true-color = "always";
      # features => named groups of settings, used to keep related settings organized
      # features = "";
    };
  };

  # lazygit config: path differs between linux (~/.config) and darwin (App Support)
  xdg.configFile = lib.mkIf (!mylib.isDarwin pkgs) {
    lazygit = {
      source = link "lazygit/";
      recursive = true;
    };
  };

  home.file = lib.mkIf (mylib.isDarwin pkgs) {
    "Library/Application Support/lazygit/config.yml".source =
      link "lazygit/config.yml";
  };
}
