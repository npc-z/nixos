{pkgs, ...}: {
  home.packages = with pkgs; [
    dig # Domain name server
    nix-search-tv # Fuzzy search for Nix packages
    inetutils # Collection of common network programs
    lsd # Next gen ls command
    erdtree # File-tree visualizer and disk usage analyzer
  ];

  home.shellAliases = {
    # Fuzzy search for Nix packages
    ns = "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    ls = "lsd";
  };
}
