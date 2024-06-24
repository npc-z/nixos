{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
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
      ms-python.debugpy
      ms-python.isort
      ms-python.python
      ms-python.vscode-pylance
      ms-toolsai.jupyter
      ms-toolsai.jupyter-keymap
      ms-toolsai.jupyter-renderers
      ms-toolsai.vscode-jupyter-cell-tags
      ms-toolsai.vscode-jupyter-slideshow
      # njqdev.vscode-python-typehint
      pkief.material-icon-theme
      # semanticdiff.semanticdiff
      shd101wyy.markdown-preview-enhanced
      visualstudioexptteam.intellicode-api-usage-examples
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };
}
