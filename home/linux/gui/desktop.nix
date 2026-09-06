{
  config,
  myvars,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtNixos + "/dotfiles";
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
      source = mkSymlink "${dotfilesRoot}/clipse/.config/clipse/config.json";
    };
    "clipse/custom_theme.json" = {
      source = mkSymlink "${dotfilesRoot}/clipse/.config/clipse/custom_theme.json";
    };

    # gamepad mapper
    antimicrox = {
      source = mkSymlink "${dotfilesRoot}/antimicrox/.config/antimicrox";
      recursive = true;
    };
  };
}
