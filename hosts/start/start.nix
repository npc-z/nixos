# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      # use OSProber instead of set extraEntries,
      # or the  default = saved option dont work
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

  networking = {
    # NOTE: update hostName
    hostName = "r9000p-nixos";
    networkmanager.enable = true;
  };

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
  };

  security.rtkit.enable = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = ["npc"];
    substituters = [
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
  };

  # Enable the OpenSSH daemon.
  services = {
    openssh = {
      enable = true;
      settings.PermitRootLogin = "yes";
    };
  };

  environment.variables.EDITOR = "vim";

  users.users.npc = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$hzAVLzc8eIFShnzWJiye/0$Wo5QHjsi98zBMcUqlUZ8Ehe6JKcekiI/rBcWLgDCuh9";
    description = "npc";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    cmake
    unzip
    which
    tree
    git
    vim
    curl
    wget
    # tools
    foot
    #
    neofetch
    btop
    lsof
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
