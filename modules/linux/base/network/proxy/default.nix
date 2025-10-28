{...}: {
  imports = [
    ./clash-verge-rev.nix
    # 失去网络连接时，内存泄露
    ./v2rava.nix
  ];
}
