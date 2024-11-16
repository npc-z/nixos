# just is a command runner, Justfile is very similar to Makefile, but simpler.

############################################################################
#
#  Nix commands related to the local machine
#
############################################################################

# rebuild
deploy:
  nixos-rebuild switch --flake . --use-remote-sudo

# rebuild with debug
debug:
  nixos-rebuild switch --flake . --use-remote-sudo --show-trace --print-build-logs --verbose

# deploy darwin
deploy-darwin:
  darwin-rebuild switch --flake . --show-trace --print-build-logs --verbose

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

# remove all generations older than 7 days
clean:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

# garbage collect all unused nix store entries
gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

# link dotfiles to config
stow:
    cd ./dotfiles && \
    stow -t $HOME \
    -R alacritty \
    -R antimicrox \
    -R clipse \
    -R dwm \
    -R foot \
    -R libinput-gestures \
    -R hypr \
    -R keyd \
    -R kitty \
    -R lazygit \
    -R neofetch \
    -R rofi \
    -R ssh \
    -R swaync \
    -R swaylock \
    -R wallpapers \
    -R swappy \
    -R waybar \
    -R vim \
    -R vscode \
    -R wlogout \
    -R wofi \
    -R zathura

    # dont need this in nixos
    rm ~/default.conf
