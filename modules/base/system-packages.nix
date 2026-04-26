{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    uv # python project package manager
    pipx # Install and Run Python Applications in Isolated Environments

    python314
    python314Packages.pip
    # sort Python imports
    isort
    # Python code formatter
    black
    # Python package installer and resolver
    nixd
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
  ];
}
