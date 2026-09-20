hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 0,
        border_size = 0,
        col = {
            active_border = "rgba(00000000)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 0.8,
        blur = {
            enabled = true,
            size = 3,
            passes = 3,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        pseudotile = true,
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },
})

hl.curve("myBezier", {
    type = "bezier",
    points = { {0.05, 0.9}, {0.1, 1.05} },
})

hl.animation({ leaf = "windows",     enabled = true, speed = 2, curve = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2, style = "popin 90%" })
hl.animation({ leaf = "border",      enabled = true, speed = 2 })
hl.animation({ leaf = "borderangle", enabled = true, speed = 2 })
hl.animation({ leaf = "fade",        enabled = true, speed = 2 })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 2 })

