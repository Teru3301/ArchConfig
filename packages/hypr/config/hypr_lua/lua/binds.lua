local mainMod = "SUPER"

local terminal = "kitty"
local fileManager = "thunar"

--
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), {})    --  перетаскивание окон
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), {})  --  масштабирование окон



hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + ESCAPE", hl.dsp.exit())
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("wofi --show drun"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))


-- 
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))


-- переключение между рабочими столами
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i)}))
end
hl.bind(mainMod .. " + 0", hl.dsp.workspace({ workspace = "10" }))


hl.bind(mainMod .. " + SHIFT + " .. 1, hl.dsp.window.move({ workspace = "1" }))
hl.bind(mainMod .. " + SHIFT + " .. 2, hl.dsp.window.move({ workspace = "2" }))


-- 
for i = 1, 9 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = "10" }))


-- 
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special({ name = "magic" }))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))


-- 
hl.bind(mainMod .. " + mouse_down", hl.dsp.workspace({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.workspace({ workspace = "e-1" }))


-- 
hl.bindel("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bindel("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bindel("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bindel("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bindel("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"))
hl.bindel("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"))


-- 
hl.bind("ALT + S", hl.dsp.exec_cmd(
    [[sh -c 'area=$(slurp) && folder="/home/teru/D/Media/Images/Screenshots/$(date +%F)" && mkdir -p "$folder" && filename="$(date +%H-%M-%S).png" && grim -g "$area" "$folder/$filename" && grim -g "$area" - | wl-copy']]
))

