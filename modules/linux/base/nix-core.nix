{...}: {
  nix = {
    # do garbage collection weekly to keep disk usage low
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 2w";
    };

    # remove nix-channel related tools & configs, we use flakes instead.
    channel.enable = false;
  };
}
