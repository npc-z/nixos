{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python312
    python312Packages.pip
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
