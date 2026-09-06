{lib, ...}: rec {
  # check if the host platform is linux and x86
  # (isx86Linux pkgs) -> true
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;

  # check if the host platform is darwin
  # (isDarwin pkgs) -> true
  isDarwin = pkgs: with pkgs.stdenv; hostPlatform.isDarwin;

  # use path relative to the root of the project
  relativeToRoot = lib.path.append ../.;

  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory") # include directories
            || (
              (path != "default.nix") # ignore default.nix
              && (lib.strings.hasSuffix ".nix" path) # include .nix files
            )
        )
        (builtins.readDir path)));

  # Import packages from a nixpkgs PR or a specific commit.
  # System architecture is derived from pkgs automatically.
  #
  # Unmerged PR (branch still exists):
  #   (importNixpkgsPR { inherit pkgs; pr = 503185; sha256 = "..."; })
  #
  # Merged PR or specific commit:
  #   (importNixpkgsPR { inherit pkgs; rev = "3764ed5"; sha256 = "..."; })
  #
  # When both pr and rev are given, rev takes precedence (more stable).
  importNixpkgsPR = {
    pkgs,
    pr ? null,
    rev ? null,
    sha256,
    config ? {},
  }: let
    url =
      if rev != null
      then "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz"
      else if pr != null
      then "https://github.com/NixOS/nixpkgs/archive/pull/${toString pr}/head.tar.gz"
      else throw "importNixpkgsPR: must provide either 'pr' or 'rev'";
  in
    import
    (fetchTarball {
      inherit url sha256;
    })
    {
      inherit config;
      system = pkgs.stdenv.hostPlatform.system;
    };

  # dotfiles: reusable bindings for linking the repo dotfiles into the home.
  #   inherit (mylib.dotfiles { inherit config myvars pkgs; }) mkSymlink dotfilesRoot link;
  #   - mkSymlink   : config.lib.file.mkOutOfStoreSymlink
  #   - dotfilesRoot: OS-aware repository dotfiles directory path
  #   - link path   : out-of-store symlink to "${dotfilesRoot}/${path}"
  dotfiles = {
    config,
    myvars,
    pkgs,
  }: let
    repoPath =
      if isDarwin pkgs
      then myvars.thisRepoPathAtDarwin
      else myvars.thisRepoPathAtNixos;
  in rec {
    mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    dotfilesRoot = repoPath + "/dotfiles";
    link = path: mkSymlink "${dotfilesRoot}/${path}";
    # link a whole config directory recursively
    linkDir = path: {
      source = link path;
      recursive = true;
    };
    # link a single config file
    linkFile = path: {
      source = link path;
    };
  };
}
