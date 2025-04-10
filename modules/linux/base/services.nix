{...}: {
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.cron.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
