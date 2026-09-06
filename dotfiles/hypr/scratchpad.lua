local mainMod = "SUPER"

hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special(""))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special" }))
