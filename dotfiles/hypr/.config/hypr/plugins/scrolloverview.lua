hl.config({
    plugin = {
        scrolloverview = {
            gesture_distance = 300,
            scale = 0.5,
            workspace_gap = 100,
            layout = "vertical",
        },
    },
})

-- Guard against plugin load failure so the config stays parseable
if hl.plugin.scrolloverview ~= nil then
    hl.bind("SUPER + o", hl.plugin.scrolloverview.overview("toggle"))
    hl.plugin.scrolloverview.gesture({ fingers = 4, direction = "vertical" })
end
