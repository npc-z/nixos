# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################


default:
  just --list


# rebuild
deploy:
  nixos-rebuild switch --flake . --use-remote-sudo

# Build the configuration and activate it, but don't add it to the bootloader menu
test:
  nixos-rebuild test --flake . --use-remote-sudo

# rebuild with debug
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --print-build-logs --verbose


# deploy darwin
deploy-darwin:
  darwin-rebuild switch --flake . --show-trace --print-build-logs --verbose
  # activateSettings -u will reload the settings from the database and apply them to the current session,
  # so we do not need to logout and login again to make the changes take effect.
  # /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u


# install darwin
install-darwin:
  nix run nix-darwin --extra-experimental-features  "nix-command flakes" -- switch --flake . --show-trace --print-build-logs --verbose


# update flake
up:
  nix flake update

# Update specific input. Usage: just upp home-manager
upp input:
  nix flake lock --update-input {{input}}

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

# garbage collect all unused nix store entries
gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old


# link dotfiles to config
stow-common:
    cd ./dotfiles && \
    stow -t $HOME \
    -R alacritty \
    -R foot \
    -R kitty \
    -R ssh \
    -R wallpapers \
    -R vim \

    # dont need this in nixos
    rm -f ~/default.conf


# stow for linux
stow-linux: stow-common
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
stow-mac: stow-common
    cd ./dotfiles && \
    stow -t $HOME \
    -R vscode-mac \
    -R karabiner \

    ln -sf ~/.config/nixos/dotfiles/lazygit/.config/lazygit/config.yml "/Users/npc/Library/Application Support/lazygit/config.yml" \
    #
    ln -sf ~/.config/nixos/dotfiles/mac-mouse-fix/config.plist "/Users/npc/Library/Application Support/com.nuebling.mac-mouse-fix/config.plist" \

