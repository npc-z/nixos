{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config = {
    packageOverrides = pkgs: {
      pr322461 =
        import
        (fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/pull/322461/head.tar.gz";
          sha256 = "0q485k0i1sd2y04bh9d1npi6f695qb9mdgxfzzl65gvma1na7mk1";
        })
        {
          config = config.nixpkgs.config;
          system = "x86_64-linux";
        };
    };
  };
  environment.systemPackages = with pkgs; [
    pr322461.eudic
  ];
}
