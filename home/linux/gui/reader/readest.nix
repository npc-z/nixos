{pkgs, ...}: {
  home.packages = with pkgs; [
    # Modern, feature-rich ebook reader
    # https://github.com/readest/readest
    readest
  ];
}
