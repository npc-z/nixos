{mylib, ...}: {
  imports = mylib.scanPaths ./.;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    TERM = "xterm-256color";
  };
}
