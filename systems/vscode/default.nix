{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      yzhang.markdown-all-in-one
      eamodio.gitlens
      ms-python.python
      ms-python.vscode-pylance
      pkief.material-icon-theme
      pkief.material-icon-theme
    ];
  };
}
