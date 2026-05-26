hl.config({
    binds = {
        allow_workspace_cycles = true,
    },
})

local primary_terminal = "kitty"
local secondary_terminal = "alacritty"
local file_manager = "nautilus"
local reader = "zathura"
local web_browser = "zen"
local mainMod = "SUPER"

hl.bind("Print", hl.dsp.exec_cmd("grim -g \"$(slurp -d)\" - | swappy -f -"))

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { repeating = true, locked = true })

hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("bash ~/.config/scripts/vol.sh up"),
    { repeating = true, locked = true }
)
hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("bash ~/.config/scripts/vol.sh down"),
    { repeating = true, locked = true }
)
hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("bash ~/.config/scripts/vol.sh toggle_mute"),
    { repeating = true, locked = true }
)

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(primary_terminal))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("hdrop -f -p bottom -h 80 -w 80 " .. primary_terminal .. " --class kitty_i"))
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd(secondary_terminal))
-- hl.bind(mainMod .. " + BACKSPACE", hl.dsp.window.close())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
-- hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(web_browser))
-- hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file_manager))
-- hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("code"))
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(reader))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))

hl.bind("SUPER + CTRL + space", hl.dsp.window.fullscreen({ maxsize = false }))
-- hl.bind(mainMod .. " + space", hl.dsp.window.fullscreen({ maxsize = true }))
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + space", hl.dsp.layout("colresize +conf"))

-- hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 .waybar-wrapped || .waybar-wrapped"))
-- hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("killall -SIGUSR2 .waybar-wrapped"))
-- hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("pkill wofi || wofi --show drun"))
hl.bind("SUPER + CTRL + P", hl.dsp.window.pin())
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("hyprlock"))

-- windows
-- move focus
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + H", hl.dsp.window.bring_to_top())
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + L", hl.dsp.window.bring_to_top())

-- move window
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- FIXME:
-- zoom in / out
hl.bind(
    "SUPER + SHIFT + minus",
    hl.dsp.exec_cmd(
        "hyprctl getoption cursor:zoom_factor | grep float | awk '{if($2!=1) system(\"hyprctl keyword cursor:zoom_factor \" $2 - 0.1) }' && hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2}' | xargs notify-send -t 1000"
    )
)
hl.bind(
    "SUPER + SHIFT + equal",
    hl.dsp.exec_cmd(
        "hyprctl getoption cursor:zoom_factor | grep float | awk '{ system(\"hyprctl keyword cursor:zoom_factor \" $2 + 0.1) }' && hyprctl getoption cursor:zoom_factor | grep float | awk '{print $2}' | xargs notify-send -t 1000"
    )
)

-- Resize submap
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.submap("resize"))
-- Switch to a submap called `resize`.
hl.bind("ALT + R", hl.dsp.submap("resize"))
-- Start a submap called "resize".
hl.define_submap("resize", function()
    -- hl.notification.create({ text = "I just resize!", duration = 3000, icon = "ok" })
    -- Set repeating binds for resizing the active window.
    hl.bind("right", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("left", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("up", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("down", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })

    -- Use `reset` to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
end)

-- workspaces
hl.bind("SUPER + J", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("SUPER + K", hl.dsp.focus({ workspace = "m-1" }))
-- mouse side buttons
hl.bind("mouse:276", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("mouse:275", hl.dsp.focus({ workspace = "m-1" }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- drag / resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
