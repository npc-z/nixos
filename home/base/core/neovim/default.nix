{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    # do not generate init.lua
    sideloadInitLua = true;

    withRuby = false;
    withNodeJs = true;
    withPython3 = true;
    extraPython3Packages = pyPkgs:
      with pyPkgs; [
        autopep8
      ];

    # defaultEditor = true;
    extraPackages = with pkgs; [
      # formatter for nix
      alejandra

      # Parser generator tool and an incremental parsing library
      tree-sitter

      go
      cargo
      luajit # required by plugin's building
      stylua
      lua-language-server

      fd
      ripgrep
      gzip
      zip
      unzip
      gnutar
      wget
      curl

      # for neovim & rust
      graphviz # Graph visualization tools

      # sql
      vimPlugins.nvim-dbee # not support on darwin
      sleek
    ];

    plugins = with pkgs.vimPlugins; [
      # nvim-dbee not work, put it at extraPackages
    ];
  };
}
