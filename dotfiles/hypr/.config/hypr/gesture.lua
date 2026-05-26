hl.config({
    gestures = {
        workspace_swipe_distance = 200,

        -- whether a swipe right on the last workspace should create a new one
        workspace_swipe_create_new = false,
    },
})

hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })

hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })

-- FIXME: refract
hl.gesture({
    fingers = 3,
    direction = "left",
    ---@diagnostic disable-next-line: assign-type-mismatch
    action = function()
        hl.notification.create({ text = "I just swiped on my trackpad LEFT!", duration = 3000, icon = "ok" })
        hl.dsp.layout("move -col")
        -- hl.dispatch(hl.dsp.window.cycle_next()) -- Change focus to another window
        -- hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
    end,
})

hl.gesture({
    fingers = 3,
    direction = "right",
    ---@diagnostic disable-next-line: assign-type-mismatch
    action = function()
        hl.notification.create({ text = "I just swiped on my trackpad RIGHT!", duration = 3000, icon = "ok" })
        hl.dsp.layout("focus r")
        -- hl.dsp.focus({ direction = "right" })
        -- hl.dsp.layout("swapcol l")
        -- hl.dispatch(hl.dsp.window.cycle_next()) -- Change focus to another window
        -- hl.dispatch(hl.dsp.window.bring_to_top()) -- Bring it to the top
    end,
})

hl.gesture({
    fingers = 4,
    direction = "down",
    mods = "SUPER",
    action = "special",
    workspace_name = "scratchpad",
    disable_inhibit = true,
})
