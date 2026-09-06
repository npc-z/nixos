{
  config,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) linkDir linkFile;

  vscodeCliArgs = [
    # https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code
    # For use with any package that implements the Secret Service API
    # (for example gnome-keyring, kwallet5, KeepassXC)
    "--password-store=gnome-libsecret"
  ];

  extensions =
    (with pkgs.vscode-marketplace; [
      # Basic
      # emeraldwalk.runonsave

      # git
      semanticdiff.semanticdiff

      # db
      cweijan.vscode-mysql-client2
      # adpyke.vscode-sql-formatter
      # mongodb.mongodb-vscode

      # doc
      # cweijan.vscode-office
      # cweijan.xmind-viewer

      # njqdev.vscode-python-typehint
    ])
    ++ (
      with pkgs.vscode-extensions; [
        # Basic
        usernamehw.errorlens # Improve highlighting of errors, warnings and other language diagnostics
        christian-kohler.path-intellisense # autocompletes filenames
        pkief.material-icon-theme
        esbenp.prettier-vscode
        formulahendry.code-runner
        gruntfuggly.todo-tree
        mechatroner.rainbow-csv
        vscodevim.vim
        # tekumara.typos-vscode # source code spell checker
        streetsidesoftware.code-spell-checker # Spelling checker for source code

        # Nix
        jnoortheen.nix-ide # Full Nix language support with/without external language servers

        # rust
        rust-lang.rust-analyzer

        # Python
        # 需要手动安装以下 python 插件，否则导致以下问题
        # A shared background process terminated unexpectedly. Please restart the application to recover.
        # ms-python.python
        # ms-python.vscode-pylance
        # ms-python.debugpy
        # ms-toolsai.jupyter
        # ms-toolsai.vscode-jupyter-slideshow
        # ms-toolsai.vscode-jupyter-cell-tags
        # ms-toolsai.jupyter-renderers
        # ms-toolsai.jupyter-keymap
        detachhead.basedpyright
        charliermarsh.ruff

        # TOML
        tamasfe.even-better-toml

        # git
        eamodio.gitlens

        # markdown
        shd101wyy.markdown-preview-enhanced
        yzhang.markdown-all-in-one
        davidanson.vscode-markdownlint

        # http
        humao.rest-client
      ]
    );

  defaultPprofiles = {
    extensions = extensions;
  };
in {
  programs.github-copilot-cli = {
    enable = true;
  };

  programs.vscode = {
    # vscode 和 vscodevim 不能共存
    # enable = true;
    profiles.default = defaultPprofiles;
    package =
      if pkgs.stdenv.hostPlatform.isLinux
      then
        pkgs.vscode.override {
          commandLineArgs = vscodeCliArgs;
        }
      else pkgs.vscode;
  };

  programs.vscodium = {
    enable = true;
    profiles.default = defaultPprofiles;
    package =
      if pkgs.stdenv.hostPlatform.isLinux
      then
        pkgs.vscodium.override {
          commandLineArgs = vscodeCliArgs;
        }
      else pkgs.vscodium;
  };

  # vscode / vscodium config: linux uses ~/.config/Code|VSCodium, darwin uses App Support
  xdg.configFile = lib.mkIf (!mylib.isDarwin pkgs) {
    "Code/User/keybindings.json" = linkFile "vscode/Code/User/keybindings.json";
    "Code/User/settings.json" = linkFile "vscode/Code/User/settings.json";
    "Code/User/snippets" = linkDir "vscode-snippets";

    "VSCodium/User/keybindings.json" = linkFile "vscode/Code/User/keybindings.json";
    "VSCodium/User/settings.json" = linkFile "vscode/Code/User/settings.json";
    "VSCodium/User/snippets" = linkDir "vscode-snippets";
  };

  home.file = lib.mkIf (mylib.isDarwin pkgs) {
    "Library/Application Support/Code/User/settings.json" = linkFile "vscode-mac/settings.json";
    "Library/Application Support/Code/User/keybindings.json" = linkFile "vscode-mac/keybindings.json";
    "Library/Application Support/Code/User/snippets" = linkDir "vscode-snippets";
  };
}
