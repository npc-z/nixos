{...}: {
  services.logind = {
    # close the Laptop lid
    lidSwitch = "ignore";

    # power button
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
}
