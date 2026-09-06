local mainMod = "SUPER"

hl.on("hyprland.start", function()
    hl.exec_cmd("clipse -listen")
end)

hl.window_rule({
    match = { class = "(floatingClipse)" },
    float = true,
})

hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("alacritty --class floatingClipse -e zsh -c 'clipse $PPID'"))
