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

local function pin_nofocus_toggle()
    local tag = "pin_nofocus"

    local function has_tag(window)
        for _, t in ipairs(window.tags or {}) do
            if t == tag then
                return true
            end
        end
        return false
    end

    return function()
        local window = hl.get_active_window()
        if not window then
            return
        end

        if window.floating and window.fullscreen == 0 and not window.pinned and not has_tag(window) then
            -- Tag the window and mark it as pinned with no_focus
            hl.dispatch(hl.dsp.window.tag({ tag = "+" .. tag, window = window }))
            hl.dispatch(hl.dsp.window.pin({ window = window }))
            hl.dispatch(hl.dsp.window.set_prop({ prop = "no_focus", value = "1", window = window }))
        else
            -- Restore all windows that were marked this way
            for _, marked_window in ipairs(hl.get_windows({ tag = tag })) do
                hl.dispatch(hl.dsp.window.set_prop({ prop = "no_focus", value = "unset", window = marked_window }))
                if marked_window.pinned then
                    hl.dispatch(hl.dsp.window.pin({ window = marked_window }))
                end
                hl.dispatch(hl.dsp.window.tag({ tag = "-" .. tag, window = marked_window }))
            end
        end
    end
end
hl.bind(mainMod .. " + SHIFT + P", pin_nofocus_toggle())

hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("plainly-panel --clipboard"))

hl.bind(
    mainMod .. " + SHIFT + D",
    hl.dsp.exec_cmd("systemctl --user start dsh-web.service && notify-send \"start dsh\"")
)
hl.bind(
    mainMod .. " + SHIFT + CTRL + D",
    hl.dsp.exec_cmd("systemctl --user stop dsh-web.service && notify-send \"stop dsh\"")
)

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
hl.bind(mainMod .. " + space", hl.dsp.layout("colresize +conf"))

hl.bind("SUPER + B", hl.dsp.exec_cmd("noctalia msg bar-toggle"))
-- hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 .waybar-wrapped || .waybar-wrapped"))
-- hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("killall -SIGUSR2 .waybar-wrapped"))
hl.bind("SUPER + P", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind("SUPER + CTRL + P", hl.dsp.window.pin())
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))
-- used when noctalia lock crashed
hl.bind("SUPER + SHIFT + ALT + L", hl.dsp.exec_cmd("hyprlock"))

-- windows
-- move focus (scrolling layout message: keeps the tape centered and still
-- scrolls away from fullscreen windows instead of jumping to another monitor)
hl.bind(mainMod .. " + H", hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + L", hl.dsp.layout("focus r"))

-- move window
-- between columns: swap the focused column with its neighbor
hl.bind("SUPER + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + SHIFT + L", hl.dsp.layout("swapcol r"))
-- inside a column: reorder with the generic dispatcher
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move({ direction = "up" }))

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
hl.bind("mouse:276", hl.dsp.focus({ workspace = "m-1" }))
hl.bind("mouse:275", hl.dsp.focus({ workspace = "m+1" }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- drag / resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Windows Magnifier-like cursor zoom
local MAX_ZOOM = 5
local MIN_ZOOM = 1
local ZOOM_TOGGLE_FACTOR = 2.5

---@param offset number
---@return nil
local function zoom(offset)
    hl.dsp.exec_cmd("notify-send hello")
    local current = hl.get_config("cursor.zoom_factor")

    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    else
        current = ZOOM_TOGGLE_FACTOR
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

hl.bind("SUPER + Z", zoom)
hl.bind("SUPER + equal", function()
    zoom(0.5)
end)
hl.bind("SUPER + minus", function()
    zoom(-0.5)
end)
