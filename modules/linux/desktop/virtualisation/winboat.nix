{
  pkgs,
  config,
  mylib,
  ...
}: {
  # pr https://github.com/NixOS/nixpkgs/pull/503185
  nixpkgs.config = {
    packageOverrides = _: {
      pr_winboat = mylib.importNixpkgsPR {
        inherit pkgs;
        pr = 503185;
        sha256 = "1qa04d5sw6f626hm5jmracdvgzgq9cx8nca2gsdff64lwd1b459i";
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # winboat
    # use the patched version of winboat until the pr is merged
    pr_winboat.winboat
  ];
}
