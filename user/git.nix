{userSettings, ...}: {
  programs.git = {
    enable = true;
    userName = "${userSettings.git.userName}";
    userEmail = "${userSettings.git.userEmail}";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      last = "log -1";
      lg = "log --color --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
    };
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };
}
