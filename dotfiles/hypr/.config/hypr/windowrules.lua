hl.window_rule({
    match = { class = ".*" },
    animation = "popin",
})

-- polkit auth dialogs float
hl.window_rule({
    match = { class = "^(.*polkit.*)$" },
    float = true,
})

-- screen sharing select dialog
hl.window_rule({
    match = { title = "^(.*Select what to share.*)$" },
    float = true,
})

-- media viewer
hl.window_rule({
    match = { title = "^.*(Media viewer).*$" },
    float = true,
})

-- vpn
hl.window_rule({
    match = { class = "^.*(clash-verge).*$" },
    float = true,
})
hl.window_rule({
    match = { class = "^([Ss]parkle)$" },
    float = true,
})

-- bluetooth devices
hl.window_rule({
    match = { title = "^.*(Bluetooth Devices).*$" },
    float = true,
})

-- Picture-in-Picture
hl.window_rule({
    match = { title = "^.*(Picture-in-Picture).*$" },
    float = true,
})

-- alacritty floating with size and opacity
hl.window_rule({
    match = { class = "^(Alacritty)$" },
    float = true,
    size = "monitor_w*0.7 monitor_h*0.5",
    opacity = 0.50,
})

-- code workspace 1
hl.window_rule({
    match = { class = "^(Code|code|codium)$" },
    workspace = "1",
})

-- browsers workspace 3
hl.window_rule({
    match = { class = "^(Microsoft-edge)$" },
    workspace = "3",
})
hl.window_rule({
    match = { class = "^(firefox)$" },
    workspace = "3",
})
hl.window_rule({
    match = { class = "^(zen-twilight)$" },
    workspace = "3",
})

hl.window_rule({
    match = { class = "^(firefox|Microsoft-edge|Google-chrome|Chromium|zen-twilight)$" },
    focus_on_activate = true,
})

-- readers workspace 4
hl.window_rule({
    match = { class = "^(org.pwmt.zathura)$" },
    workspace = "4",
})
hl.window_rule({
    match = { class = "^.*(okular).*$" },
    workspace = "4",
})

-- chat apps workspace 5
hl.window_rule({
    match = { class = "^(weixin)$" },
    workspace = "5",
    float = true,
})
hl.window_rule({
    match = { class = "^(wechat)$" },
    workspace = "5",
    float = true,
})
hl.window_rule({
    match = { class = "^(QQ)$" },
    workspace = "5",
    float = true,
})
hl.window_rule({
    match = { class = "^(org.telegram.desktop)$" },
    workspace = "5",
    float = true,
})
hl.window_rule({
    match = { class = "^(Bytedance-feishu)$" },
    workspace = "5",
})

-- music workspace 6
hl.window_rule({
    match = { class = "^(electron-netease-cloud-music)$" },
    workspace = "6",
    float = true,
})
hl.window_rule({
    match = { class = "^(netease-cloud-music)$" },
    workspace = "6",
    float = true,
})
hl.window_rule({
    match = { title = "^(Cloud Music)$" },
    float = true,
    pin = true,
})
hl.window_rule({
    match = { class = "^(com.gitee.gmg137.NeteaseCloudMusicGtk4)$" },
    workspace = "6",
    float = true,
})
hl.window_rule({
    match = { class = "^top.imsyy.splayer_next$" },
    workspace = "6",
    float = true,
})

-- file managers workspace 7
hl.window_rule({
    match = { class = "^(nemo)$" },
    workspace = "7",
})
hl.window_rule({
    match = { class = "^(spacedrive)$" },
    workspace = "7",
})
hl.window_rule({
    match = { class = "^.*(Nautilus).*$" },
    workspace = "7",
})

-- steam / gaming workspace 10
hl.window_rule({
    match = { class = "^(steam)$" },
    workspace = "10",
    float = true,
})
hl.window_rule({
    match = { title = "^(AntiMicroX)$" },
    workspace = "10",
    float = true,
})

hl.workspace_rule({
    workspace = "2",
    on_created_empty = "kitty",
    default = true,
})

hl.window_rule({
    name = "xwayland-video-bridge-fixes",
    match = { class = "xwaylandvideobridge" },
    no_initial_focus = true,
    no_focus = true,
    no_anim = true,
    no_blur = true,
    max_size = { 1, 1 },
    opacity = 0.0,
})
