{...}: {
  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Enable sound.
  # NOTE: this is no longer has any effect
  # sound.enable = true;

  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };
}
