{lib, ...}: {
  # check if the host platform is linux and x86
  # (isx86Linux pkgs) -> true
  isx86Linux = pkgs: with pkgs.stdenv; hostPlatform.isLinux && hostPlatform.isx86;

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
}
