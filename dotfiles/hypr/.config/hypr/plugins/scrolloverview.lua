hl.config({
    plugin = {
        scrolloverview = {
            gesture_distance = 200,
            scale = 0.65,
            workspace_gap = 100,
            layout = "vertical",
            wallpaper = 0, -- 0: global only, 1: per-workspace only, 2: both
            blur = false, -- blur only the main overview wallpaper

            shadow = {
                enabled = true,
                range = 50,
            },
        },
    },
})

-- Guard against plugin load failure so the config stays parseable
if hl.plugin.scrolloverview ~= nil then
    hl.bind("SUPER + o", hl.plugin.scrolloverview.overview("toggle"))
    hl.plugin.scrolloverview.gesture({ fingers = 4, direction = "vertical" })
end
