{pkgs, ...}: let
  vscodeCliArgs = [
    # https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code
    # For use with any package that implements the Secret Service API
    # (for example gnome-keyring, kwallet5, KeepassXC)
    "--password-store=gnome-libsecret"
  ];
in {
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      # adpyke.vscode-sql-formatter  # install from vscode-extensions market
      christian-kohler.path-intellisense
      # codeium.codeium
      cweijan.dbclient-jdbc
      # cweijan.vscode-mysql-client2
      # cweijan.vscode-office
      # cweijan.xmind-viewer
      davidanson.vscode-markdownlint
      eamodio.gitlens
      # emeraldwalk.runonsave
      esbenp.prettier-vscode
      formulahendry.code-runner
      gruntfuggly.todo-tree
      humao.rest-client
      mechatroner.rainbow-csv
      # mongodb.mongodb-vscode
      # ms-python.debugpy
      # ms-python.isort
      # ms-python.python
      # ms-python.vscode-pylance
      # ms-toolsai.jupyter
      # ms-toolsai.jupyter-keymap
      # ms-toolsai.jupyter-renderers
      # ms-toolsai.vscode-jupyter-cell-tags
      # ms-toolsai.vscode-jupyter-slideshow
      # njqdev.vscode-python-typehint
      pkief.material-icon-theme
      # semanticdiff.semanticdiff
      shd101wyy.markdown-preview-enhanced
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  programs.vscode.package =
    if pkgs.stdenv.hostPlatform.isLinux
    then
      pkgs.vscode.override {
        commandLineArgs = vscodeCliArgs;
      }
    else pkgs.vscode;
}
