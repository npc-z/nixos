{
  pkgs,
  config,
  ...
}: {
  # pr https://github.com/NixOS/nixpkgs/pull/506080
  nixpkgs.config = {
    packageOverrides = pkgs: {
      pr_tree_sitter =
        import
        (fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/pull/506080/head.tar.gz";
          sha256 = "1hsz8ay2jfqgw23xv2ypivnyx7l48m1ww2sspcs8y3qvikcq8sgg";
        })
        {
          config = config.nixpkgs.config;
          system = "x86_64-linux";
        };
    };
  };

  environment.systemPackages = with pkgs; [
    pr_tree_sitter.tree-sitter
  ];
}
