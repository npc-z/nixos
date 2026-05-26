hl.window_rule({
    match = { class = "^(Bytedance-feishu)$" },
    float = true,
})
hl.window_rule({
    match = { title = "^(.*会话记录.*)$" },
    float = true,
})
hl.window_rule({
    match = { title = "^(.*飞书会议.*)$" },
    float = true,
})
hl.window_rule({
    match = { class = "^(Bytedance)$" },
    float = true,
})
