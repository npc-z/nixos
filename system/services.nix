{...}: {
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.v2raya.enable = true;

  services.cron.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  services.acpid = {
    enable = true;
    # inspired by https://www.reddit.com/r/NixOS/comments/14qa7d8/control_both_suspend_and_brightness_on_lid_close

    # dont work for me
    lidEventCommands = ''
      # export PATH=$PATH:/run/current-system/sw/bin
      export PATH=/run/wrappers/bin:/run/current-system/sw/bin:$PATH
      export DISPLAY=":0.0"

      export LID_STATE=$(cat /proc/acpi/button/lid/LID/state | awk '{print $NF}')
      if [[ $LID_STATE == "closed" ]]; then
        # mute
        pamixer -m
        # lock with hyprlock
        hyprlock

      else
        # umute
        pamixer -u
      fi
    '';

    # work for me
    powerEventCommands = ''
      systemctl suspend
    '';
  };

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
