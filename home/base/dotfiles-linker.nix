{
  config,
  lib,
  mylib,
  myvars,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  inherit (lib) map mergeAttrsList;

  isDarwin = mylib.isDarwin pkgs;

  repoPath =
    if isDarwin
    then myvars.thisRepoPathAtDarwin
    else myvars.thisRepoPathAtNixos;

  dotfilesRoot = repoPath + "/dotfiles";

  linkTo = name: mkOutOfStoreSymlink "${dotfilesRoot}/${name}";

  linkFile = name: {
    ${name}.source = linkTo name;
  };

  linkDir = name: {
    ${name} = {
      source = linkTo name;
      recursive = true;
    };
  };

  linkStowLikeDir = name: {
    ${name} = {
      source = linkTo "${name}/.config/${name}";
      recursive = true;
    };
  };

  ##################################################################
  #                       linux
  ##################################################################

  linuxConfFiles = map linkFile [
    #
  ];

  linuxConfDirs = map linkDir [
    #
  ];

  linuxStowLikeDirs = map linkStowLikeDir [
    #
    "alacritty"
    "antimicrox"
    "clipse"
    "foot"
    "keyd"
    "kitty"
    "lazygit"
    "scripts"
    "swappy"
    "swaylock"
    "swaync"
    "wallpapers"
    "waybar"
    "wlogout"
    "wofi"
    "zathura"
  ];

  linuxConfigFiles = {
    # starship
    "starship.toml".source = linkTo "starship/.config/starship.toml";

    # vscode
    "Code/User/keybindings.json".source = linkTo "vscode/.config/Code/User/keybindings.json";
    "Code/User/settings.json".source = linkTo "vscode/.config/Code/User/settings.json";

    # libinput-gestures
    "libinput-gestures.conf".source = linkTo "libinput-gestures/.config/libinput-gestures.conf";
  };

  linuxHomeFiles = {
    # vim
    ".vimrc".source = linkTo "vim/.vimrc";

    # ssh
    ".ssh/config".source = linkTo "ssh/.ssh/config";
  };

  ##################################################################
  #                       darwin
  ##################################################################

  darwinConfFiles = map linkFile [
    #
  ];

  darwinConfDirs = map linkDir [
    #
  ];
  darwinStowLikeDirs = map linkStowLikeDir [
    #
  ];

  darwinHomeFiles = {
    #
  };

  xdgConfigFile =
    if isDarwin
    then
      # darwin
      mergeAttrsList (
        darwinConfFiles
        ++ darwinConfDirs
        ++ darwinStowLikeDirs
      )
    else
      # linux
      (
        mergeAttrsList (
          linuxConfFiles
          ++ linuxConfDirs
          ++ linuxStowLikeDirs
        )
      )
      // linuxConfigFiles
    #
    ;

  homeFile =
    if isDarwin
    then darwinHomeFiles
    else linuxHomeFiles;
in {
  xdg.configFile = xdgConfigFile;

  home.file = homeFile;
}
