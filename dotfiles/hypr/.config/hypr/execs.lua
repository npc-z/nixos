hl.on("hyprland.start", function()
    hl.exec_cmd("mkdir -p ~/screenshots")

    -- hl.exec_cmd("libinput-gestures > /tmp/libinput-gestures-npc.log 2>&1 &")

    -- home-manager handled dbus-update-activation-environment

    hl.exec_cmd("noctalia")
    hl.exec_cmd("fcitx5 -d --replace")
    hl.exec_cmd("brightnessctl s 50%")
    hl.exec_cmd("pamixer --set-volume 50")
    hl.exec_cmd("foot --server")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    -- hl.exec_cmd("libinput-gestures-setup restart")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
    hl.exec_cmd("sparkle")
end)
