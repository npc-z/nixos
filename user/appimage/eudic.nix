{pkgs, ...}: {
  home.packages = with pkgs; [
    (appimageTools.wrapType2 rec {
      pname = "eudic";
      version = "2024-04-19";
      src = fetchurl {
        url = "https://static-main.frdic.com/pkg/eudic.AppImage?v=${version}";
        sha256 = "sha256-W14Qf8mbcAv7UZ0uyvaHe78RfO7nzI94THhOC+iwoqM=";
      };
    })
  ];
}
