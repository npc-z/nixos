{ config, lib, pkgs, ... }:

{
    boot.loader = {
        grub = {
            enable = true;
            device = "nodev";
            # do not need to keep too much generations
            # boot.loader.systemd-boot.configurationLimit = 10;
            configurationLimit = 10;
            efiSupport = true;
            extraEntries = ''
                menuentry "Windows" {
                    search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
                        chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
                }
            '';
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
        };
    };
}
