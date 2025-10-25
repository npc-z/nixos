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
  ];

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

  link_list =
    if isDarwin
    then darwinConfFiles ++ darwinConfDirs ++ darwinStowLikeDirs
    else linuxConfFiles ++ linuxConfDirs ++ linuxStowLikeDirs;

  links = mergeAttrsList link_list;
in {
  xdg.configFile = links;
}
