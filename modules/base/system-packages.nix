{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    uv # python project package manager
    # FIXME: cant pass tests
    # pipx # Install and Run Python Applications in Isolated Environments

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
    fastfetch

    # lsp for dev
    nixd # nix
    inputs.tix.packages.${stdenv.hostPlatform.system}.default # nix

    # just
    just-lsp
  ];
}
