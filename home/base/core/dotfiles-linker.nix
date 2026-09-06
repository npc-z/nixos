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
    "niri"
    "cava"
    "flameshot"
    # A sleek, minimal, and thoughtfully crafted desktop shell for Wayland using Quickshell
    "noctalia"
    "swayidle"
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
    "wallpapers"
    "zathura"
  ];

  linuxConfigFiles = {
    # starship
    "starship.toml".source = linkTo "starship/.config/starship.toml";

    # vscode
    "Code/User/keybindings.json".source = linkTo "vscode/.config/Code/User/keybindings.json";
    "Code/User/settings.json".source = linkTo "vscode/.config/Code/User/settings.json";
    "Code/User/snippets" = {
      source = linkTo "vscode-snippets";
      recursive = true;
    };

    # VSCodium
    "VSCodium/User/keybindings.json".source = linkTo "vscode/.config/Code/User/keybindings.json";
    "VSCodium/User/settings.json".source = linkTo "vscode/.config/Code/User/settings.json";
    "VSCodium/User/snippets" = {
      source = linkTo "vscode-snippets";
      recursive = true;
    };

    # opencode
    "opencode/opencode.jsonc".source = linkTo "opencode/opencode.jsonc";
    "opencode/tui.jsonc".source = linkTo "opencode/tui.jsonc";

    # libinput-gestures
    "libinput-gestures.conf".source = linkTo "libinput-gestures/.config/libinput-gestures.conf";

    "mimeapps.list".source = linkTo "xdg/mimeapps.list";

    # hypr - linked individually so Home Manager can also generate files inside .config/hypr/
    "hypr/animations.lua".source = linkTo "hypr/.config/hypr/animations.lua";
    "hypr/base.lua".source = linkTo "hypr/.config/hypr/base.lua";
    "hypr/binds.lua".source = linkTo "hypr/.config/hypr/binds.lua";
    "hypr/debug.lua".source = linkTo "hypr/.config/hypr/debug.lua";
    "hypr/execs.lua".source = linkTo "hypr/.config/hypr/execs.lua";
    "hypr/general.lua".source = linkTo "hypr/.config/hypr/general.lua";
    "hypr/gesture.lua".source = linkTo "hypr/.config/hypr/gesture.lua";
    "hypr/hyprlock.conf".source = linkTo "hypr/.config/hypr/hyprlock.conf";
    "hypr/input.lua".source = linkTo "hypr/.config/hypr/input.lua";
    "hypr/others.lua".source = linkTo "hypr/.config/hypr/others.lua";
    "hypr/scratchpad.lua".source = linkTo "hypr/.config/hypr/scratchpad.lua";
    "hypr/windowrules.lua".source = linkTo "hypr/.config/hypr/windowrules.lua";
    "hypr/apps" = {
      source = linkTo "hypr/.config/hypr/apps";
      recursive = true;
    };
    "hypr/hosts" = {
      source = linkTo "hypr/.config/hypr/hosts";
      recursive = true;
    };
    "hypr/plugins" = {
      source = linkTo "hypr/.config/hypr/plugins";
      recursive = true;
    };
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
    "alacritty"
    "erdtree"
    "kitty"
    "scripts"
    "wallpapers"
  ];

  darwinConfigFiles = {
    # starship
    "starship.toml".source = linkTo "starship/.config/starship.toml";

    # "karabiner"
    # WARNING: 在软件中修改配置之后, 会将这个链接删除掉
    # 最好再重新手动同步一次配置到这个仓库中
    "karabiner/karabiner.json" = {
      source = linkTo "karabiner/karabiner.json";
      #  覆盖软件产生的 backup 文件
      # force = true;
    };
  };

  darwinHomeFiles = {
    # vim
    ".vimrc".source = linkTo "vim/.vimrc";

    # ssh
    ".ssh/config".source = linkTo "ssh/.ssh/config";

    # lazygit
    "Library/Application Support/lazygit/config.yml".source = linkTo "lazygit/.config/lazygit/config.yml";

    # vscode
    "Library/Application Support/Code/User/settings.json".source = linkTo "vscode-mac/settings.json";
    "Library/Application Support/Code/User/keybindings.json".source = linkTo "vscode-mac/keybindings.json";
    "Library/Application Support/Code/User/snippets" = {
      source = linkTo "vscode-snippets";
      recursive = true;
    };

    # mac-mouse-fix
    # WARNING: 在软件中修改配置之后, 会将这个链接删除掉
    # 最好再重新手动同步一次配置到这个仓库中
    "Library/Application Support/com.nuebling.mac-mouse-fix/config.plist".source = linkTo "mac-mouse-fix/config.plist";
    # "Library/Application Support/com.nuebling.mac-mouse-fix/config.plist".force = true;
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
      // darwinConfigFiles
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
