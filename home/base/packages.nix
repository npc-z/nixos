{pkgs, ...}: {
  home.packages = with pkgs; [
    dig # Domain name server
    nix-search-tv # Fuzzy search for Nix packages
    inetutils # Collection of common network programs
    lsd # Next gen ls command
    erdtree # File-tree visualizer and disk usage analyzer

    mkcert # Simple tool for making locally-trusted development certificates
  ];

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
