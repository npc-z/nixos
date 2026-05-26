hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 4,
        border_size = 2,

        layout = "scrolling",

        -- enables resizing windows by clicking and dragging on borders and gaps
        resize_on_border = true,
    },
})

hl.config({
    decoration = {
        rounding = 12,

        active_opacity = 1,
        inactive_opacity = 0.95,
        fullscreen_opacity = 1,

        blur = {
            -- the higher passes will require more strain on the GPU, default is 1
            passes = 1,
        },
    },
})

-- Layouts
hl.config({
    dwindle = {
        preserve_split = true,
    },

    master = {
        mfact = 0.5,
        new_on_top = true,
    },

    scrolling = {
        explicit_column_widths = "0.5, 0.75, 1.0",
    },

    misc = {
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
    },

    cursor = {
        hide_on_key_press = true,
    },
})

-- FIXME: refract
-- Fallback monitor to prevent crash when monitor power cycles
hl.monitor({
    output = "FALLBACK",
    mode = "1920x1080@60",
    position = "auto",
    scale = 1,
})
