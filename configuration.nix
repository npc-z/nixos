# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ];

# Use the systemd-boot EFI boot loader.
# boot.loader.systemd-boot.enable = true;
# boot.loader.efi.canTouchEfiVariables = true;

    fonts.packages = with pkgs; [
        (nerdfonts.override {
            fonts = [
            "JetBrainsMono"
            "FiraCode"
            ];
        })
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
    ];

    boot.loader = {
        grub = {
            enable = true;
            device = "nodev";
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

    networking = {
        hostName = "nixos";
        networkmanager.enable = true;
        extraHosts = ''
            140.82.113.4	github.com
            185.199.108.133 raw.githubusercontent.com
            185.199.109.133 raw.githubusercontent.com
            185.199.110.133 raw.githubusercontent.com
            185.199.111.133 raw.githubusercontent.com
            '';
    };

# networking.hostName = "nixos"; # Define your hostname.
# Pick only one of the below networking options.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
# networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

# Set your time zone.
    time.timeZone = "Asia/Shanghai";

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Select internationalisation properties.
# i18n.defaultLocale = "en_US.UTF-8";
# console = {
#   font = "Lat2-Terminus16";
#   keyMap = "us";
#   useXkbConfig = true; # use xkb.options in tty.
# };

# Enable the X11 windowing system.
# services.xserver.enable = true;




# Configure keymap in X11
# services.xserver.xkb.layout = "us";
# services.xserver.xkb.options = "eurosign:e,caps:escape";

# Enable CUPS to print documents.
# services.printing.enable = true;

# Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
    };

    security.rtkit.enable = true;

# Enable touchpad support (enabled default in most desktopManager).
# services.xserver.libinput.enable = true;
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

# Define a user account. Don't forget to set a password with ‘passwd’.
# users.users.alice = {
#   isNormalUser = true;
#   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
#   packages = with pkgs; [
#     firefox
#     tree
#   ];
# };

# List packages installed in system profile. To search, run:
# $ nix search wget
# environment.systemPackages = with pkgs; [
#   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#   wget
# ];

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# List services that you want to enable:

# Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.keyd.enable = true;
    services.v2raya.enable = true;

    # environment.etc."keyd/default.conf".source = /home/npc/.config/keyd/default.conf;
    environment.etc."keyd/default.conf".text = builtins.readFile ./pkgs/keyd/default.conf;

    environment.variables.EDITOR = "vim";
    users.defaultUserShell = pkgs.zsh;

    # environment.shellAliases = {
    # };

    programs = {
        hyprland = {
            enable = true;
        };
        waybar  = {
            enable = true;
        };
        zsh = {
            enable = true;
            shellAliases = {
                "vim" = "nvim";
                "cls" = "clear";
                "gs" = "git st";
                "ga" = "git add .";
                "gco" = "git co";
                "gl" = "git lg";
                # gac = 'git add . && git commit -m "update $(date "+%Y-%m-%d %H:%M:%S")"';
                gacp = "gac && git push";
                gpl = "git pull";
                gps = "git push";
                lg = "lazygit";
            };
            ohMyZsh = {
                enable = true;
                theme = "amuse";
            };
        };
    };

    users.users.npc = {
        isNormalUser = true;
        description = "npc";
        extraGroups = [
            "networkmanager"
                "wheel"
        ];
        packages = with pkgs; [
            firefox
        ];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
            python311
            python311Packages.pip
            gnumake
            gcc9
            zsh
            go
            nodejs_20
            fd
            ripgrep
            cmake
            unzip
            vscode
            which
            tree
            git
            lazygit
            vim
            neovim
            curl
            wget
# tools
            glow
            kitty
            foot
            cinnamon.nemo
            vscode
            zathura
            wofi
            netease-cloud-music-gtk
#
            neofetch
            btop
            lsof
            keyd
            stow
            v2raya
# desktop
            microsoft-edge
            hyprland
            waybar
            swaybg
            brightnessctl
            pamixer
            fcitx5
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

