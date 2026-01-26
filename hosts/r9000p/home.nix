{mylib, ...}: {
  imports = [
    (mylib.relativeToRoot "home/linux/home.nix")
  ];

  config = {
    wm = {
      hyprland = {
        enable = true;
        host = "r9000p";
      };
      niri = {
        enable = true;
      };
    };

    modules = {
    };
  };
}
