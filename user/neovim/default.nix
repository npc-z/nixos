{pkgs, ...}: {
  programs.neovim = {
    enable = true;

    withNodeJs = true;
    withPython3 = true;

    # defaultEditor = true;
    extraPackages = with pkgs; [
      # formatter for nix
      alejandra

      go
      cargo
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

      # sql
      vimPlugins.nvim-dbee
      sleek
    ];

    plugins = with pkgs.vimPlugins; [
      # nvim-dbee not work, put it at extraPackages
    ];
  };
}
