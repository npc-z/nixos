{...}: {
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.cron.enable = true;

  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
