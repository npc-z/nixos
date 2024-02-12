{pkgs, ...}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      yzhang.markdown-all-in-one
      eamodio.gitlens
      ms-python.python
      ms-python.vscode-pylance
      ms-pyright.pyright
      pkief.material-icon-theme
      pkief.material-icon-theme
    ];
  };
}
