{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  repoPath =
    if mylib.isDarwin pkgs
    then myvars.thisRepoPathAtDarwin
    else myvars.thisRepoPathAtNixos;
  dotfilesRoot = repoPath + "/dotfiles";
in {
  home.packages = with pkgs; [
    # A cat(1) clone with syntax highlighting and Git integration
    bat
    # network
    arp-scan # ARP scanning and fingerprinting tool
    dig # Domain name server
    inetutils # Collection of common network programs
    nmap # Network discovery and security auditing

    # nix
    nix-search-tv # Fuzzy search for Nix packages

    lsd # Next gen ls command
    erdtree # File-tree visualizer and disk usage analyzer

    mkcert # Simple tool for making locally-trusted development certificates
  ];

  xdg.configFile.erdtree = {
    source = mkSymlink "${dotfilesRoot}/erdtree/.config/erdtree";
    recursive = true;
  };

  home.shellAliases = {
    # Fuzzy search for Nix packages
    ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    ls = "lsd";
  };

  # another Nix CLI helper
  programs.nh = {
    enable = true;
  };
}
