{
  config,
  lib,
  pkgs,
  ...
}: {
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

  # boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
  #   pname = "distro-grub-themes";
  #   version = "3.1";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "AdisonCavani";
  #     repo = "distro-grub-themes";
  #     rev = "v3.1";
  #     hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
  #   };
  #   installPhase = "cp -r customize/nixos $out";
  # };

  # boot.loader.grub.theme = pkgs.stdenv.mkDerivation {
  #     name = "bigsur-grub2-theme";
  #     src = pkgs.fetchFromGitHub {
  #         owner = "Teraskull";
  #         repo = "bigsur-grub2-theme";
  #         rev = "5bf0a9711282e4463eec82bb4430927fdc9c662a";
  #         hash = "sha256-BSZHTd6Eg/QZ1ekGTd3W+xHI6RbSmwCrcDxaCWD/DbI=";
  #     };
  #     installPhase = "cp -r bigsur $out";
  # };
}
