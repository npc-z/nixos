{...}: {
  # zswap: a compressed cache in front of the disk swap device. Cold pages are
  # evicted to disk on an LRU basis, so the hot working set stays in compressed
  # RAM. zram (a hard-limited block device with no eviction of its own) would
  # invert the LRU once a disk swap device is present, so we no longer use it.
  #   https://chrisdown.name/2026/03/24/zswap-vs-zram-when-to-use-what.html
  boot.zswap = {
    enable = true;
    # the kernel default is off; without this zswap only evicts when the pool
    # limit is hit instead of tiering cold pages out proactively
    shrinkerEnabled = true;
  };

  # zram + zswap would compress twice; NixOS asserts they are never both on
  zramSwap.enable = false;
}
