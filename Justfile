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

# update flake
up:
  nix flake update

# Update specific input. Usage: make upp i=home-manager
upp:
  nix flake lock --update-input $(i)

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
    -R foot \
    -R hypr \
    -R keyd \
    -R kitty \
    -R lazygit \
    -R neofetch \
    -R swaync \
    -R swaylock \
    -R wallpapers \
    -R waybar \
    -R vim \
    -R vscode \
    -R wlogout \
    -R wofi \
    -R zathura

