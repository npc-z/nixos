{
  pkgs,
  config,
  ...
}: {
  # pr https://github.com/NixOS/nixpkgs/pull/503185
  nixpkgs.config = {
    packageOverrides = pkgs: {
      pr_winboat =
        import
        (fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/pull/503185/head.tar.gz";
          sha256 = "1qa04d5sw6f626hm5jmracdvgzgq9cx8nca2gsdff64lwd1b459i";
        })
        {
          config = config.nixpkgs.config;
          system = "x86_64-linux";
        };
    };
  };

  environment.systemPackages = with pkgs; [
    # winboat
    # use the patched version of winboat until the pr is merged
    pr_winboat.winboat
  ];
}
