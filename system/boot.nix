{pkgs, ...}: {
  # Use latest kernel for the initial installation.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader = {
    grub = {
      enable = true;
      default = "saved";
      device = "nodev";
      # 使用了 theme 导致配置被覆盖
      font = "${pkgs.fira-code}/share/fonts/truetype/FiraCode-VF.ttf";
      fontSize = 48;

      # do not need to keep too much generations
      # boot.loader.systemd-boot.configurationLimit = 10;
      configurationLimit = 10;
      efiSupport = true;
      useOSProber = true;
      # 使用 OSProber 代替手动设置 extraEntries
      # 否侧 default = saved 设置项不起作用
      # extraEntries = ''
      #   menuentry "Windows" {
      #       search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
      #           chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
      #   }
      # '';
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };
}
