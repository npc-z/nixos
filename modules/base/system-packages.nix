{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # node
    nodejs
    pnpm

    # python
    uv # python project package manager
    pipx

    python314
    python314Packages.pip
    # sort Python imports
    isort
    # Python code formatter
    black
    # Python package installer and resolver
    gnumake

    curl
    httpie
    wget
    jq

    zip
    unzip

    tree
    which

    just # use Justfile to simplify nix-darwin's commands

    # lsp for dev
    nixd # nix
    inputs.tix.packages.${stdenv.hostPlatform.system}.default # nix
    # formatter for nix
    alejandra

    # just
    just-lsp
  ];
}
