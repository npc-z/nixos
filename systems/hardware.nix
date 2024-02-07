{ config, lib, pkgs, ... }:

{
    # Set your time zone.
    time.timeZone = "Asia/Shanghai";

    # Enable sound.
    sound.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    hardware.pulseaudio.enable = false;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
    };
}
