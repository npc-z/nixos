{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    cargo
    # Simple terminal UI for both docker and docker-compose
    lazydocker
  ];
}
