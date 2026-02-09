{pkgs, ...}: {
  home.packages = with pkgs;
    if stdenv.hostPlatform.isLinux
    then [
      firefox
    ]
    else [
    ];
}
