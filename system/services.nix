{...}: {
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.v2raya.enable = true;

  services.cron.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

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
            # a = "home";
            # e = "end";
          };
          shift = {
            "'" = "'";
          };
          "control+shift" = {
            # select all
            # "a" = "C-a";
            # del to end of line
            # "k" = "C-k";
            # "h" = "backspace";
            # "d" = "delete";
          };
        };
      };
    };
  };
}
