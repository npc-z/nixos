{pkgs, ...}: {
  # foot is designed only for Linux
  home.packages = with pkgs;
    if stdenv.hostPlatform.isLinux
    then [
      foot
    ]
    else [];
}
