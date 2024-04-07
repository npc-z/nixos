{...}: {
  nix = {
    settings = {
      # Optimise storage
      # you can alse optimise the store manually via:
      #    nix-store --optimise
      # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      trusted-users = ["npc"];
      substituters = [
        # cache mirror located in China
        # status: https://mirror.sjtu.edu.cn/
        "https://mirror.sjtu.edu.cn/nix-channels/store"

        # status: https://mirrors.ustc.edu.cn/status/
        "https://mirrors.ustc.edu.cn/nix-channels/store"

        "https://cache.nixos.org"

        # nix community's cache server
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        # the default public key of cache.nixos.org, it's built-in, no need to add it here
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

        # nix community's cache server public key
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2w";
    };
  };
}
