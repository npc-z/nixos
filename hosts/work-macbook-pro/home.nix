{
  mylib,
  pkgs,
  ...
}: {
  imports = [
    (mylib.relativeToRoot "home/darwin")
  ];

  config = {
    modules = {
      opencode = {
        enable = true;
      };
    };

    packages = with pkgs; [
      # archives
      zip
      xz
      unzip
      p7zip

      # utils
      ripgrep # recursively searches directories for a regex pattern
      jq # A lightweight and flexible command-line JSON processor
      # yq-go # yaml processer https://github.com/mikefarah/yq
      fzf # A command-line fuzzy finder

      # misc
      cowsay
      file
      which
      tree
      gnused
      gnutar
      gawk
      zstd
      caddy
      gnupg

      # productivity
      glow # markdown previewer in terminal
      # jetbrains.idea-community
      jetbrains.idea
      eza
    ];

    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.05";
  };
}
