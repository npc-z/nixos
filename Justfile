# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################


default:
  @just --list --unsorted


# rebuild
[linux]
deploy:
  # nixos-rebuild switch --flake . --sudo
  nh os switch --ask . --accept-flake-config

# Build the configuration and activate it, but don't add it to the bootloader menu
[linux]
test:
  # nixos-rebuild test --flake . --sudo
  nh os test --ask . --accept-flake-config

# rebuild with debug
[linux]
debug:
  # nixos-rebuild switch --flake . --sudo --show-trace --print-build-logs --verbose
  nh os test --ask --verbose . --accept-flake-config


# remote build
[linux]
remote-test host:
  # e.g. nixos-rebuild test --use-remote-sudo --target-host npc@r9000p-nixos --flake ./#r9000p-nixos --ask-sudo-password
  nixos-rebuild test --use-remote-sudo --target-host npc@{{host}} --flake ./#{{host}} --elevate=sudo --ask-elevate-password


# deploy darwin
[macos]
deploy: update-mac-self-managed-cfgs
  # darwin-rebuild switch --flake . --show-trace --print-build-logs --verbose
  nh darwin switch --ask . --accept-flake-config
  # activateSettings -u will reload the settings from the database and apply them to the current session,
  # so we do not need to logout and login again to make the changes take effect.
  # /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u


# build darwin
[macos]
build: update-mac-self-managed-cfgs
  # darwin-rebuild build --flake . --show-trace --print-build-logs --verbose
  nh darwin build . --accept-flake-config


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


# link dotfiles to config
_stow-common:
    cd ./dotfiles && \
    stow -t $HOME \
    -R alacritty \
    -R foot \
    -R kitty \
    -R scripts \
    -R ssh \
    -R starship \
    -R wallpapers \
    -R vim \

    # dont need this in nixos
    rm -f ~/default.conf


# stow for linux
[linux]
stow: _stow-common
    cd ./dotfiles && \
    stow -t $HOME \
    -R antimicrox \
    -R clipse \
    -R dwm \
    -R libinput-gestures \
    -R hypr \
    -R keyd \
    -R lazygit \
    -R rofi \
    -R swaync \
    -R swaylock \
    -R swappy \
    -R waybar \
    -R vscode \
    -R wlogout \
    -R wofi \
    -R zathura \


# stow for mac
[macos]
stow: _stow-common
    cd ./dotfiles && \
    stow -t $HOME \
    -R vscode-mac \
    -R karabiner \

    brew install lihaoyun6/tap/topit

    ln -sf ~/.config/nixos/dotfiles/lazygit/.config/lazygit/config.yml "/Users/npc/Library/Application Support/lazygit/config.yml" \
    #
    # ln -sf ~/.config/nixos/dotfiles/mac-mouse-fix/config.plist "/Users/npc/Library/Application Support/com.nuebling.mac-mouse-fix/config.plist" \


# https://github.com/niri-wm/niri/issues/1682#issuecomment-4115318288
# 生成 niri 的 zsh 补全脚本
gen-niri-competions:
    niri completions zsh | sed "s/line\[2\]/line[1]/g; /'::command/d" > home/base/core/shell/scripts/niri.zsh


# Check packages against Hydra without updating
safe-update-nix:
  nix run github:sircam-html/safe-update-nix -- --check

