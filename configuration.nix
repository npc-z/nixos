{ config, lib, pkgs, ... }:

{
    imports = [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];


    fonts.packages = with pkgs; [
        (nerdfonts.override {
            fonts = [
            "JetBrainsMono"
            "FiraCode"
            ];
        })
        noto-fonts noto-fonts-cjk noto-fonts-emoji
        liberation_ttf
        fira-code fira-code-symbols
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


    # Set your time zone.
    time.timeZone = "Asia/Shanghai";

    # Enable sound.
    sound.enable = true;
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

    # List services that you want to enable:
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.v2raya.enable = true;

    services.keyd = {
        enable = true;
        keyboards = {
            default = {
                ids = ["*"];
                settings = {
                    main = {
                        # capslock = "control"; # do not work
                        capslock = "oneshot(control)";
                        "'" = ''"'';
                    };
                    control = {
                        h = "left";
                        j = "down";
                        k = "up";
                        l = "right";
                    };
                    shift = {
                        "'" = "'";
                    };
                };
            };
        };
    };

    environment.variables.EDITOR = "vim";
    users.defaultUserShell = pkgs.zsh;

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
        python311 python311Packages.pip go nodejs_20
        gnumake gcc9 cmake
        lsof fd ripgrep unzip which tree
        vscode
        git lazygit
        vim neovim
        curl wget
        # tools
        kitty foot
        cinnamon.nemo glow zathura
        netease-cloud-music-gtk

        neofetch btop
        zsh keyd stow
        # desktop
        microsoft-edge
        hyprland waybar swaybg wofi
        brightnessctl pamixer
        fcitx5 v2raya
    ];

    system.stateVersion = "24.05"; # Did you read the comment?
}

