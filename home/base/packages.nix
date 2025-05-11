{pkgs, ...}: {
  home.packages = with pkgs; [
    # Fuzzy search for Nix packages
    nix-search-tv
    # Collection of common network programs
    inetutils
    lsd # Next gen ls command
    erdtree # File-tree visualizer and disk usage analyzer
  ];

  home.shellAliases = {
    # Fuzzy search for Nix packages
    ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    ls = "lsd";
  };
}
