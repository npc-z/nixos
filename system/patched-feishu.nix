{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config = {
    packageOverrides = pkgs: {
      pr311904 =
        import
        (fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/pull/311904/head.tar.gz";
          sha256 = "1ngrhsi20zs2c70ihs422wq7vva0w6150bxxhd70q4jgfaxlc9xr";
        })
        {
          config = config.nixpkgs.config;
          system = "x86_64-linux";
        };
    };
  };

  environment.systemPackages = with pkgs; [
    pr311904.feishu
  ];
}
