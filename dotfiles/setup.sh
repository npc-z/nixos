#!/bin/bash

# The following will attempt to install all needed packages to run Hyprland
#
# hyprland: the Hyprland compositor
# kitty: for float terminal
# foot: normal terminal
# wofi: the application launcher menu
# pamixer: This helps with audio settings such as volume
# brightnessctl: used to control monitor bright level
# swaybg: set wallpaper
# wl-clipboard:
# imv: view image
# mako: nofify(del)
# swaync: nofify
# swaylock-effects-git: lock screen
# erdtree: replace tree and du
# libinput-gesture: 额外的 gesture (https://github.com/bulletmark/libinput-gestures)
# grim & slurp: for screenshot
# fonts:

# xdotool as dependence for libinput-gesture

sudo pacman -S \
    hyprland \
    kitty \
    foot \
    wofi \
    pamixer \
    brightnessctl \
    swaybg \
    wl-clipboard \
    imv \
    mako \
    xdotool \
    grim \
    slurp \
    yay

yay -S \
    swaylock-effects-git \
    erdtree \
    swaync \
    libinput-gestures
