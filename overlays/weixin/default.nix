(final: prev: {
  # https://github.com/NixOS/nixpkgs/pull/293730
  wechat-uos = prev.wechat-uos.override {
    # 需要自己下载 license
    # https://github.com/NixOS/nixpkgs/pull/293730#discussion_r1523599387
    # https://github.com/NixOS/nixpkgs/blob/d8fe5e6c92d0d190646fb9f1056741a229980089/pkgs/by-name/we/wechat-uos/package.nix#L63
    uosLicense = builtins.fetchurl {
      name = "license.tar.gz";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/license.tar.gz?h=wechat-uos-bwrap";
      sha256 = "0sdx5mdybx4y489dhhc8505mjfajscggxvymlcpqzdd5q5wh0xjk";
    };
  };
})
