{ config, lib, pkgs, ... }:

{
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
                "https://mirror.sjtu.edu.cn/nix-channels/store"
                    "https://cache.nixos.org"
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
