hl.monitor({
    output = "desc:California Institute of Technology 0x1609",
    mode = "2560x1600@165.02Hz",
    position = "0x0",
    scale = 1.33,
})

hl.monitor({
    output = "desc:AOC U2790B 0x0001743F",
    disabled = true,
})

hl.config({
    cursor = {
        no_hardware_cursors = 2,
    },
})

hl.on("hyprland.start", function()
    hl.exec_cmd("rfkill unblock bluetooth")
end)

require("plugins.hyprbars")
require("plugins.scrolloverview")
