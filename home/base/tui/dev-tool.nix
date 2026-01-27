{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    cargo
    # Simple terminal UI for both docker and docker-compose
    lazydocker
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
