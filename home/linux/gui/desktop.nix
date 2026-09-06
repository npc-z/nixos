{
  config,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (mylib.dotfiles {inherit config myvars pkgs;}) link;
in {
  home.packages = with pkgs; [
    # clipboard
    wl-clipboard
    clipse

    # GUI for mapping keyboard and mouse controls to a gamepad
    # note: 只支持有线连接(Xbox 🎮)
    antimicrox
  ];

  home.sessionVariables = {
    # force Qt/Chromium/Electron apps to use the Wayland (Ozone) backend
    NIXOS_OZONE_WL = "1";
    # preferred editor
    EDITOR = "nvim";
  };

  xdg.configFile = {
    # clipse clipboard manager: only link config files, exclude runtime data
    # (clipboard_history.json, tmp_files/)
    "clipse/config.json" = {
      source = link "clipse/config.json";
    };
    "clipse/custom_theme.json" = {
      source = link "clipse/custom_theme.json";
    };

    # gamepad mapper
    antimicrox = {
      source = link "antimicrox/";
      recursive = true;
    };
  };
}
