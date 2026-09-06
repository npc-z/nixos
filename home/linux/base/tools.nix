{pkgs, ...}: {
  home.packages = with pkgs; [
    # user CLI / TUI tools
    fd
    ripgrep
    vim
    glow
    tldr
    eza
    file
    htop
    btop
    stow
  ];
}
