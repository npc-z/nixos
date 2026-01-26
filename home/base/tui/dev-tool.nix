{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    cargo
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
}
