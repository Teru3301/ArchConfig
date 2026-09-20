hl.window_rule({
    name = "suppress_maximize",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "float_qalculate",
    match = { class = "^(qalculate-gtk)$" },
    float = true,
})

