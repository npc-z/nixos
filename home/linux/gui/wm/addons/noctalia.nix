{
  config,
  inputs,
  myvars,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  dotfilesRoot = myvars.thisRepoPathAtNixos + "/dotfiles";
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
  };

  xdg.configFile.noctalia = {
    source = mkSymlink "${dotfilesRoot}/noctalia";
    recursive = true;
  };
}
