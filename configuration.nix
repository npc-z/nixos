{ config, lib, pkgs, ... }:

{
    imports = [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    i18n = {
        defaultLocale = "en_US.UTF-8";
        supportedLocales = [
            "zh_CN.UTF-8/UTF-8"
            "en_US.UTF-8/UTF-8"
        ];
        inputMethod = with pkgs; {
            enabled = "fcitx5";
            fcitx5 = {
                addons = [
                    fcitx5-chinese-addons
                    fcitx5-configtool
                    fcitx5-gtk
                ];
            };
        };
    };

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
            # 140.82.113.4	github.com
            # 185.199.108.133 raw.githubusercontent.com
            # 185.199.109.133 raw.githubusercontent.com
            # 185.199.110.133 raw.githubusercontent.com
            # 185.199.111.133 raw.githubusercontent.com
            # 20.201.28.151 github.com
            # 20.205.243.166 github.com
            # 20.87.245.0 github.com
            # 20.248.137.48 github.com
            # 20.207.73.82 github.com
            # 20.27.177.113 github.com
            # 20.200.245.247 github.com
            # 20.175.192.147 github.com
            # 20.233.83.145 github.com
            # 20.29.134.23 github.com
            # 20.201.28.152 github.com
            # 20.205.243.160 github.com
            # 20.87.245.4 github.com
            # 20.248.137.50 github.com
            # 20.207.73.83 github.com
            # 20.27.177.118 github.com
            # 20.200.245.248 github.com
            # 20.175.192.146 github.com
            # 20.233.83.149 github.com
            # 20.29.134.19 github.com
            '';
    };


    # Set your time zone.
    time.timeZone = "Asia/Shanghai";

    # Enable sound.
    sound.enable = true;

    hardware.bluetooth.enable = true; # enables support for Bluetooth
    hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

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

    virtualisation.docker.enable = true;

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
        direnv = {
            enable = true;
            silent = true;
        };
        hyprland = {
            enable = true;
        };
        waybar  = {
            enable = true;
        };
        zsh = {
            enable = true;
            # z - jump around
            # source ${pkgs.fetchurl {url = "https://github.com/rupa/z/raw/2ebe419ae18316c5597dd5fb84b5d8595ff1dde9/z.sh"; sha256 = "0ywpgk3ksjq7g30bqbhl9znz3jh6jfg8lxnbdbaiipzgsy41vi10";}}
            # export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
            # export ZSH_THEME="lambda"
            # plugins=(git)
            # source $ZSH/oh-my-zsh.sh
            interactiveShellInit = ''
                source ~/.config/nixos/dotfiles/shell/basic.sh

                # z-lua 初始化
                eval "$(z.lua  --init zsh)"

                eval "$(direnv hook zsh)"
                '';
            shellAliases = {
                "vim" = "nvim";
                "cls" = "clear";
                "gs" = "git st";
                "ga" = "git add .";
                "gco" = "git co";
                "gl" = "git lg";
                "gac" = ''git add . && git commit -m "update $(date "+%Y-%m-%d %H:%M:%S")"'';
                "gacp" = "gac && git push";
                "gpl" = "git pull";
                "gps" = "git push";
                "lg" = "lazygit";
            };
            autosuggestions = {
                enable = true;
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
            "docker"
        ];
        packages = with pkgs; [
            firefox
        ];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
        python311 python311Packages.pip go nodejs_20 cargo
        gnumake gcc9 cmake
        lsof fd ripgrep unzip which tree
        vscode
        # make dev env
        devbox docker
        # common tools
        git lazygit delta
        vim neovim
        curl wget wl-clipboard
        # tools
        kitty foot
        cinnamon.nemo glow zathura
        netease-cloud-music-gtk playerctl

        neofetch btop
        zsh z-lua keyd stow
        # desktop
        microsoft-edge
        hyprland waybar swaybg wofi wlogout pamixer brightnessctl
        #
        brightnessctl pamixer
        v2raya
    ];

    system.stateVersion = "24.05"; # Did you read the comment?

    # do not need to keep too much generations
    # boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.grub.configurationLimit = 10;

    # do garbage collection weekly to keep disk usage low
    nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 2w";
    };

    # Optimise storage
    # you can alse optimise the store manually via:
    #    nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    nix.settings.auto-optimise-store = true;
}

