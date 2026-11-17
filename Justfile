# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################


default:
  @just --list --unsorted


# deploy:
[linux]
deploy:
  # nixos-rebuild switch --flake . --sudo
  @just _nrs "switch"


# boot
[linux]
boot:
  # nixos-rebuild boot --flake . --sudo
  @just _nrs "boot"


# build
[linux]
build:
  # nixos-rebuild build --flake . --sudo
  @just _nrs "build"


# Build the configuration and activate it, but don't add it to the bootloader menu
[linux]
test:
  # nixos-rebuild test --flake . --sudo
  @just _nrs "test"


# build with debug
[linux]
debug:
  nixos-rebuild build --flake . --sudo --show-trace --print-build-logs --verbose


# 校验 darwin 配置：在 Linux 上做 eval + 整图实例化（真构建需要 macOS runner 或 remote builder）
[linux]
check-darwin:
  nix build --dry-run .#darwinConfigurations.work-macbook-pro.config.system.build.toplevel
  nix build --dry-run .#darwinConfigurations.work-macbook-pro.config.home-manager.users.npc.home.activationPackage


# Build this host's config on another machine over SSH
[linux]
build-by-remote host:
  nixos-rebuild build --flake . --build-host npc@{{host}} --accept-flake-config


# export noctalia config to dotfiles
[linux]
expoet-noctalia-gui-config:
  noctalia config export > dotfiles/noctalia/settings.toml

# deploy darwin
[macos]
deploy: update-mac-self-managed-cfgs
  darwin-rebuild switch --flake . --show-trace --print-build-logs --verbose


# build darwin
[macos]
build: update-mac-self-managed-cfgs
  darwin-rebuild build --flake . --show-trace --print-build-logs --verbose


# install darwin
[macos]
install-darwin:
  nix run nix-darwin --extra-experimental-features  "nix-command flakes" -- switch --flake . --show-trace --print-build-logs --verbose


# update flake
up:
  nix flake update


# Update specific input. Usage: just upp home-manager
upp input:
  nix flake update {{input}}


# Update ai tools: agents and skills
up-ai:
  nix flake update llm-agents
  nix flake update skills-catalog


# history of profile
history:
  nix profile history --profile /nix/var/nix/profiles/system


# repl with nixpkgs
repl:
  nix repl -f flake:nixpkgs


# repl the configurations
repl-configurations:
  nix repl --extra-experimental-features 'flakes repl-flake' .


# remove all generations older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
  nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager


# Get sha256 of a nixpkgs PR tarball. Usage: just pr-hash 503185
pr-hash pr:
  nix-prefetch-url --unpack "https://github.com/NixOS/nixpkgs/archive/pull/{{pr}}/head.tar.gz"


# Get sha256 of a nixpkgs commit tarball. Usage: just rev-hash 3764ed5
rev-hash rev:
  nix-prefetch-url --unpack "https://github.com/NixOS/nixpkgs/archive/{{rev}}.tar.gz"


# garbage collect all unused nix store entries
gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old


# 将自我管理的软件的配置更新回 dotfiles 中
[macos]
update-mac-self-managed-cfgs:
    #!/usr/bin/env sh

    rewrite_back_to_dotfile() {
        local source_file="$1"
        local target_file="$2"

        if [ ! -e "$source_file" ]; then
            echo "${source_file} 文件不存在"
            return 1
        elif [ ! -s "$source_file" ]; then
            echo "${source_file} 文件存在但内容为空"
            return 2
        else
            echo "回写 ${source_file} → ${target_file}"

            content=$(< "$source_file")
            echo "$content" > "$target_file"
            return 0
        fi
    }

    source_mac_mouse_fix_path=~/Library/Application\ Support/com.nuebling.mac-mouse-fix/config.plist
    target_mac_mouse_fix_path=./dotfiles/mac-mouse-fix/config.plist
    rewrite_back_to_dotfile "$source_mac_mouse_fix_path" "$target_mac_mouse_fix_path"

    source_karabiner_path=~/.config/karabiner/karabiner.json
    target_karabiner_path=./dotfiles/karabiner/karabiner.json
    rewrite_back_to_dotfile "$source_karabiner_path" "$target_karabiner_path"


[private]
_nrs action:
    #!/usr/bin/env bash
    set -Eeuo pipefail

    action="{{action}}"

    case "$action" in
        build|test|boot|switch)
            ;;
        *)
            echo "Unsupported action: $action" >&2
            exit 2
            ;;
    esac

    # 1. Build the system with ROM.
    echo "==> Building NixOS configuration..."

    nixos-rebuild build \
        --flake . \
        --log-format internal-json \
        2>&1 | rom

    # 2. Resolve the newly built system.
    new_system="$(readlink -f -- result)"

    if [[ ! -x "$new_system/bin/switch-to-configuration" ]]; then
        echo "Error: Invalid NixOS system closure: $new_system" >&2
        exit 1
    fi

    echo ""
    echo "==> New system: $new_system"

    # 3. Show package changes with NVD.
    echo ""
    echo "==> Comparing system generations..."

    nvd diff /run/current-system "$new_system"

    # 4. Build-only mode.
    if [[ "$action" == "build" ]]; then
        echo ""
        echo "Build completed. System was not activated."
        exit 0
    fi

    # 5. Confirm activation.
    echo ""
    read -r -p "Activate this generation with '$action'? [y/N] " answer

    case "$answer" in
        [yY]|[yY][eE][sS])
            ;;
        *)
            echo "Cancelled. No changes were made."
            echo "Built system: $new_system"
            exit 0
            ;;
    esac

    # 6. Activate exactly the system reviewed by NVD.
    echo ""
    echo "==> Activating NixOS configuration..."

    sudo nixos-rebuild \
        --store-path "$new_system" \
        "$action"

    echo ""
    echo "NixOS rebuild completed successfully."

