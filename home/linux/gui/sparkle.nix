{myvars, ...}: let
  sparkleDir = "/home/${myvars.username}/.config/sparkle";
in {
  # Sparkle seeds its bundled assets from the read-only Nix store into these two
  # runtime directories with the mode preserved (0444 files, 0555 directories),
  # so later in-place updates fail with EACCES. They are the only read-only
  # paths under ~/.config/sparkle, whose own 0700 mode must stay untouched.
  # "Z" recurses, covering nested directories and assets added in the future.
  # tmpfiles cannot set per-type modes on one line ("~" is a no-op on systemd
  # 261), so files also pick up the execute bit.
  systemd.user.tmpfiles.rules = map (dir: "Z ${sparkleDir}/${dir} 0755 - - -") [
    "work"
    "test"
  ];
}
