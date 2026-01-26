{mylib, ...}: {
  imports = [
    (mylib.relativeToRoot "home/linux/home.nix")
  ];

  config = {
    wm = {
      hyprland = {
        enable = true;
        host = "ser7";
      };
      niri = {
        enable = true;
      };
      addons = {
        hypridle = {
          lock_timeout = 60 * 30; # 30 minutes
          dpms_off_timeout = 60 * 60; # 1 hour
        };
      };
    };

    modules = {
    };
  };
}
