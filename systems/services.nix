{ config, lib, pkgs, ... }:

{
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.v2raya.enable = true;

    services.keyd = {
        enable = true;
        keyboards = {
            default = {
                ids = ["*"];
                settings = {
                    main = {
                        # capslock = "control"; # do not work
                        capslock = "oneshot(control)";
                        "'" = ''"'';
                    };
                    control = {
                        h = "left";
                        j = "down";
                        k = "up";
                        l = "right";
                    };
                    shift = {
                        "'" = "'";
                    };
                };
            };
        };
    };
}
