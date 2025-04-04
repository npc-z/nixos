{...}: let
  keydConfig = builtins.readFile ./../../../dotfiles/keyd/default.conf;
in {
  # Key remapping daemon for Linux
  environment.etc."keyd/default.conf".text = keydConfig;

  services.keyd = {
    enable = true;
    # keyboards = {
    #   default = {
    #     ids = ["*"];
    #     settings = {
    #       main = {
    #         # capslock = "control"; # do not work
    #         capslock = "oneshot(control)";
    #         "'" = ''"'';
    #       };
    #       control = {
    #         h = "left";
    #         j = "down";
    #         k = "up";
    #         l = "right";
    #         # a = "home";
    #         # e = "end";
    #       };
    #       shift = {
    #         "'" = "'";
    #       };
    #       "control+shift" = {
    #         # select all
    #         # "a" = "C-a";
    #         # del to end of line
    #         # "k" = "C-k";
    #         # "h" = "backspace";
    #         # "d" = "delete";
    #       };
    #     };
    #   };
    # };
  };
}
