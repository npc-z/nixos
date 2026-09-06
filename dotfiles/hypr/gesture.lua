hl.config({
    gestures = {
        workspace_swipe_distance = 100,

        -- whether a swipe right on the last workspace should create a new one
        workspace_swipe_create_new = false,
    },
})

hl.gesture({ fingers = 2, direction = "pinch", action = "cursorZoom", zoom_level = 1, mode = "live" })

hl.gesture({ fingers = 3, direction = "vertical", action = "workspace" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "scroll_move" })
