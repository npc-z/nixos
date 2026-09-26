{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    cargo
    # TOML toolkit written in Rust
    taplo

    # Simple terminal UI for both docker and docker-compose
    lazydocker
  ];
}
